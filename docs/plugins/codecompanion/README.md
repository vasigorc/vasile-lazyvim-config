# CodeCompanion.nvim

Configuration lives in [`lua/plugins/codecompanion.lua`](../../../lua/plugins/codecompanion.lua).
This is the single point of reference for configuring it.

The config wires CodeCompanion to policy-approved, proxied LLM endpoints when the
matching environment variables are set, and falls back to upstream
direct-provider endpoints for personal use when they are not. It also registers
two optional agentic adapters that talk to a local coding-agent CLI over ACP.

## Adapters at a glance

| Name           | Transport   | What it is                                              | Billing                          |
| -------------- | ----------- | ------------------------------------------------------- | -------------------------------- |
| `claude_proxy` | HTTP        | Claude via proxy URL, else `api.anthropic.com`          | Proxy account, else API key      |
| `openai`       | HTTP        | GPT via an OpenAI-compatible Responses proxy            | Proxy account, else API key      |
| `deepseek`     | HTTP        | DeepSeek direct                                         | `DEEPSEEK_API_KEY`               |
| `anthropic`    | HTTP        | Anthropic direct                                        | `ANTHROPIC_API_KEY`              |
| `ollama_qwen`  | HTTP        | Local Ollama (`qwen2.5-coder`)                          | Local, free                      |
| `claude_code`  | ACP         | Claude Code CLI over the `claude-agent-acp` bridge      | Claude Pro/Max **subscription**  |
| `pi`           | ACP         | Pi coding agent over the `pi-acp` bridge                | Whatever `pi` is configured with |

HTTP adapters drive chat, inline (`:CodeCompanion`) and background title
generation. ACP adapters drive **chat only** — see
[acp-support.md](acp-support.md).

## Quick start

```sh
cp .env.sample .env      # then edit; .env is gitignored
```

Set `CC_DEFAULT_ADAPTER` to any adapter name above (unset defaults to
`claude_proxy`). Everything else is optional. See [env-vars.md](env-vars.md).

## Picking an adapter

- **Per machine:** `CC_DEFAULT_ADAPTER` in `.env` (plus `CC_INLINE_ADAPTER` /
  `CC_TITLE_ADAPTER` for the non-chat paths).
- **Per invocation:** `:CodeCompanionChat adapter=pi` (tab-completes).
- **Live, in a chat buffer:** `ga` opens the adapter picker.

## More

- [env-vars.md](env-vars.md) — every variable the config reads.
- [prerequisites.md](prerequisites.md) — treesitter parser, node, optional bridges.
- [acp-support.md](acp-support.md) — how the `claude_code` and `pi` ACP adapters work.
