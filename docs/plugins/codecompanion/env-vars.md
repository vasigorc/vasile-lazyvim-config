# CodeCompanion environment variables

All values are optional. They are read by
[`lua/plugins/codecompanion.lua`](../../../lua/plugins/codecompanion.lua) at
startup. Set them in your shell startup file or in a gitignored `.env` (see
[`.env.sample`](../../../.env.sample)). Anything already exported by the shell
wins over `.env`, so a machine that already exports these behaves unchanged.

## Adapter selection

`CC_DEFAULT_ADAPTER`

- Adapter for chat + inline interactions. Unset falls back to `claude_proxy`.
- Any adapter name from the table in [README.md](README.md), e.g. `openai`,
  `deepseek`, `claude_code`, `pi`.

`CC_DEFAULT_MODEL`

- Overrides the model within the chosen adapter. Must be a model that adapter
  knows (see its `schema.model.choices`). Unset uses the adapter's default.
- With `CC_DEFAULT_ADAPTER=claude_code`, use the Claude Code form: `opus` or `sonnet`.

`CC_INLINE_ADAPTER` / `CC_INLINE_MODEL`

- Adapter/model for inline (`:CodeCompanion`). Inline requires an HTTP adapter.
- Unset: inline follows the chat default while that is HTTP, otherwise falls
  back to `claude_proxy`. See [acp-support.md](acp-support.md).

`CC_TITLE_ADAPTER` / `CC_TITLE_MODEL`

- Adapter/model for background chat-title generation. Defaults to
  `claude_proxy` / Haiku. Point it at a provider you have balance with so
  failed title requests do not spam errors.

## ACP bridge command overrides

`CC_CLAUDE_ACP_CMD`

- Path to the `claude-agent-acp` bridge binary. Default: `claude-agent-acp` on
  PATH. Set this if it is not on the PATH Neovim inherits.

`CC_PI_ACP_CMD`

- Optional path to another `pi-acp` bridge binary. By default the config uses
  `scripts/pi-acp-codecompanion`, a compatibility launcher around the globally
  installed `pi-acp`. The launcher prevents pi-acp 0.0.31 from completing an ACP
  turn on a non-final `agent_end` event from pi >= 0.80.4. An override bypasses
  that compatibility fix, so use it only with a bridge that waits for
  `agent_settled`.

`PI_ACP_PACKAGE_ROOT`

- Optional package-directory override used by the local Pi launcher. Normally it
  discovers global pi-acp through pnpm, then npm. Set this only for a nonstandard
  installation; the directory must contain `dist/index.js`.

`PI_ACP_PI_COMMAND`

- Optional path to the Pi executable used by both pi-acp and the compatibility
  launcher's version check. Unset defaults to `pi` on PATH.

## Proxy endpoints

Usually exported by your shell; listed here for reference.

`CLAUDE_PROXY_URL`

- URL override for the `claude_proxy` adapter. Unset falls back to the upstream
  Anthropic messages URL.

`CLAUDE_PROXY_API_KEY_CMD`

- Command that prints an API key / short-lived token for `claude_proxy`. Prefer
  a token-printing command over a literal token. Unset falls back to
  `echo $ANTHROPIC_API_KEY`.

`OPENAI_RESPONSES_PROXY_URL`

- Direct URL for the OpenAI-compatible Responses API used by the `openai` adapter.

`OPENAI_COMPAT_PROXY_URL`

- Base or chat-completions URL used to derive the Responses URL when
  `OPENAI_RESPONSES_PROXY_URL` is unset. A trailing `/chat/completions` is
  rewritten to `/responses`; `OPENAI_API_BASE` is the next fallback, then the
  upstream OpenAI Responses URL.

`OPENAI_COMPAT_PROXY_API_KEY_CMD`

- Command that prints an API key / token for the `openai` adapter. Unset falls
  back to `echo $PERSONAL_OPENAI_API_KEY`. Avoid relying on a workspace-injected
  `OPENAI_API_KEY` unless its matching base URL is also configured.

## Direct-provider keys

Prefer a secrets file (e.g. `~/.zshrc.secrets`); set here only if you must.

- `DEEPSEEK_API_KEY` — for the `deepseek` adapter.
- `ANTHROPIC_API_KEY` — for the `anthropic` adapter and the `claude_proxy` fallback.

## Public-config rules

- Do not commit company-specific hostnames, repository remotes, proxy URLs,
  token commands, or literal tokens.
- Use generic env var names in public dotfiles.
- Keep real values in your private shell startup file or another ignored local override.
- For work docs, publish only the approved/proxied setup and omit
  direct-provider fallback examples.
