import assert from "node:assert/strict";
import test from "node:test";

import { patchPiAcpSource } from "../scripts/pi-acp-agent-settled-loader.mjs";

test("waits for agent_settled instead of agent_end", () => {
  const source = `switch (type) {
      case "agent_end": {
        completePrompt();
        break;
      }
    }`;

  const patched = patchPiAcpSource(source);

  assert.match(patched, /case "agent_end": \{\s*break;\s*\}/);
  assert.match(patched, /case "agent_settled": \{\s*completePrompt\(\);/);
});

test("leaves a bridge with native agent_settled support unchanged", () => {
  const source = 'case "agent_settled": { completePrompt(); }';

  assert.equal(patchPiAcpSource(source), source);
});

test("rejects an unsupported bridge shape", () => {
  assert.throws(
    () => patchPiAcpSource("export const bridge = true;"),
    /Unsupported pi-acp build: agent_end handler not found/,
  );
});
