# ACP adapters (Claude Code, Pi)

Most adapters in this config are HTTP: they POST to an LLM endpoint. The
`claude_code` and `pi` adapters are different — they are **ACP** adapters.
Instead of calling an HTTP endpoint, CodeCompanion spawns a local bridge
subprocess that speaks the Agent Client Protocol (JSON-RPC over stdio) and
drives a full coding-agent CLI. That agent runs with its own tools, project
settings, and session state.

Both are entirely optional and off by default: they are only used when `.env`
selects them (or you pick them in the adapter picker), so the HTTP adapters stay
the default and are unaffected.

## `claude_code`

Spawns the `claude-agent-acp` bridge, which drives the Claude Code CLI, so
Opus/Sonnet run against a Claude Pro/Max **subscription** instead of consuming
API credits.

The adapter strips `ANTHROPIC_API_KEY` / `ANTHROPIC_AUTH_TOKEN` from the
bridge's environment only (the HTTP adapters still receive them). This is
deliberate: Claude Code treats `ANTHROPIC_API_KEY` as taking precedence over the
claude.ai login, so if Neovim inherited that key the bridge would bill
pay-as-you-go API credits — exactly what this adapter exists to avoid — and
would fail outright ("Credit balance is too low") on an empty API account.

Model selection uses the Claude Code form: `CC_DEFAULT_MODEL=opus` (or `sonnet`).
Binary override: `CC_CLAUDE_ACP_CMD`.

## `pi`

Spawns the `pi-acp` bridge, which speaks ACP over stdio and runs `pi --mode rpc`
— the same integration model as `claude-agent-acp`.

Pi owns its own provider/model/auth configuration, so there is **no proxy
plumbing** in the adapter: it routes through whatever gateway the `pi` CLI is
configured for, and authenticates itself (`pi` config / `pi-acp --terminal-login`),
so the adapter injects no token. Project skills, prompts and `CLAUDE.md` are
loaded by `pi` itself. Because the adapter reads no secrets, it is safe to keep
in a public config. Binary override: `CC_PI_ACP_CMD`.

Caveats (bridge is young, MVP centered on Zed):

- No ACP `fs/*` or `terminal/*` delegation — pi reads/writes/executes locally.
- MCP servers advertised over ACP are not wired into pi unless you also run a
  pi-side MCP adapter; pi's own project MCP config still applies.

## Chat only — why inline and titles stay HTTP

ACP adapters drive **chat only**. Two other code paths are HTTP-only:

- **Inline** (`:CodeCompanion`) bails on `adapter.type ~= "http"`.
- **Title generation** (history extension) is a plain HTTP request.

So the config guards against an ACP adapter leaking into those paths (`is_acp`):

- Inline follows the chat default while that default is HTTP; if the chat
  default is an ACP adapter, inline falls back to `claude_proxy` (override with
  `CC_INLINE_ADAPTER`).
- Title generation falls back to `claude_proxy` / Haiku if pointed at an ACP
  adapter (override with `CC_TITLE_ADAPTER`).

Net effect: you can safely set `CC_DEFAULT_ADAPTER=pi` (or `claude_code`) and
chat runs through the agent while inline edits and background titles keep
working over HTTP.

## Selecting per interaction

- **Chat vs inline are independent.** `interactions.chat.adapter` and
  `interactions.inline.adapter` are wired separately in the config.
- **Per invocation:** `:CodeCompanionChat adapter=pi` (tab-completes; also
  accepts `model=`).
- **Live in a chat buffer:** `ga` opens the adapter picker.
