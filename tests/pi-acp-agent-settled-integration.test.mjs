import assert from "node:assert/strict";
import { mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { createInterface } from "node:readline";
import { spawn } from "node:child_process";
import test from "node:test";
import { fileURLToPath } from "node:url";

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const launcher = path.join(repoRoot, "scripts", "pi-acp-codecompanion");

function startBridge(env) {
  const child = spawn(launcher, [], {
    cwd: repoRoot,
    env,
    stdio: ["pipe", "pipe", "pipe"],
  });
  const messages = [];
  const waiters = [];
  const stderr = [];

  createInterface({ input: child.stdout }).on("line", (line) => {
    const message = JSON.parse(line);
    messages.push(message);
    for (const waiter of waiters.splice(0)) waiter();
  });
  child.stderr.on("data", (chunk) => stderr.push(chunk));

  return {
    child,
    messages,
    send(message) {
      child.stdin.write(`${JSON.stringify(message)}\n`);
    },
    async waitFor(predicate, timeoutMs = 10_000) {
      const deadline = Date.now() + timeoutMs;
      while (!messages.some(predicate)) {
        if (Date.now() >= deadline) {
          throw new Error(`Timed out waiting for ACP message. stderr: ${Buffer.concat(stderr).toString()}`);
        }
        await new Promise((resolve) => {
          const timeout = setTimeout(resolve, 25);
          waiters.push(() => {
            clearTimeout(timeout);
            resolve();
          });
        });
      }
      return messages.find(predicate);
    },
  };
}

test("settles ACP prompts after Pi retries and cancellation", async () => {
  const directory = await mkdtemp(path.join(tmpdir(), "pi-acp-settled-"));
  const fakePi = path.join(directory, "pi");
  await writeFile(
    fakePi,
    `#!/usr/bin/env node
import { createInterface } from "node:readline";
if (process.argv.includes("--version")) {
  console.log("pi coding agent\\n0.80.6");
  process.exit(0);
}
const send = (value) => console.log(JSON.stringify(value));
let waitingForAbort = false;
createInterface({ input: process.stdin }).on("line", (line) => {
  const request = JSON.parse(line);
  let data = {};
  if (request.type === "get_state") {
    data = { model: { provider: "fake", id: "model" }, thinkingLevel: "off", sessionFile: null };
  } else if (request.type === "get_available_models") {
    data = { models: [{ provider: "fake", id: "model", name: "Fake" }] };
  } else if (request.type === "get_commands") {
    data = { commands: [] };
  }
  send({ type: "response", id: request.id, command: request.type, success: true, data });
  if (request.type === "prompt" && request.message === "cancel me") {
    waitingForAbort = true;
    send({ type: "agent_start" });
    send({
      type: "message_update",
      message: {},
      assistantMessageEvent: { type: "text_delta", contentIndex: 0, delta: "READY_TO_CANCEL", partial: {} },
    });
  } else if (request.type === "prompt") {
    send({ type: "agent_start" });
    send({ type: "agent_end", messages: [], willRetry: true });
    setTimeout(() => {
      send({
        type: "message_update",
        message: {},
        assistantMessageEvent: { type: "text_delta", contentIndex: 0, delta: "AFTER_RETRY", partial: {} },
      });
      send({ type: "agent_settled" });
    }, 25);
  } else if (request.type === "abort" && waitingForAbort) {
    waitingForAbort = false;
    send({ type: "agent_end", messages: [] });
    send({ type: "agent_settled" });
  }
});
`,
    { mode: 0o755 },
  );

  const bridge = startBridge({
    ...process.env,
    PATH: `${directory}:${process.env.PATH}`,
    PI_ACP_PI_COMMAND: fakePi,
  });

  try {
    bridge.send({
      jsonrpc: "2.0",
      id: 1,
      method: "initialize",
      params: { protocolVersion: 1, clientCapabilities: {}, clientInfo: { name: "test", version: "1" } },
    });
    await bridge.waitFor((message) => message.id === 1);

    bridge.send({
      jsonrpc: "2.0",
      id: 2,
      method: "session/new",
      params: { cwd: directory, mcpServers: [] },
    });
    const session = await bridge.waitFor((message) => message.id === 2);

    bridge.send({
      jsonrpc: "2.0",
      id: 3,
      method: "session/prompt",
      params: {
        sessionId: session.result.sessionId,
        prompt: [{ type: "text", text: "test" }],
      },
    });
    await bridge.waitFor((message) => message.id === 3);

    const retryOutputIndex = bridge.messages.findIndex(
      (message) => message.params?.update?.content?.text === "AFTER_RETRY",
    );
    const promptResponseIndex = bridge.messages.findIndex((message) => message.id === 3);
    assert.notEqual(retryOutputIndex, -1, "assistant output emitted after agent_end should reach ACP");
    assert.ok(retryOutputIndex < promptResponseIndex, "ACP should complete only after retry output is emitted");

    bridge.send({
      jsonrpc: "2.0",
      id: 4,
      method: "session/prompt",
      params: {
        sessionId: session.result.sessionId,
        prompt: [{ type: "text", text: "cancel me" }],
      },
    });
    await bridge.waitFor((message) => message.params?.update?.content?.text === "READY_TO_CANCEL");
    bridge.send({
      jsonrpc: "2.0",
      method: "session/cancel",
      params: { sessionId: session.result.sessionId },
    });
    const cancelled = await bridge.waitFor((message) => message.id === 4);
    assert.equal(cancelled.result.stopReason, "cancelled");
  } finally {
    bridge.child.kill();
    await rm(directory, { recursive: true, force: true });
  }
});
