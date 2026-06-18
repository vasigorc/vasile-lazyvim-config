# Environment variables for Neovim

This local Neovim config keeps environment-specific endpoints and token commands out of Lua plugin files.

Define these in your shell startup file, then restart Neovim or source the file before launching Neovim.

## CodeCompanion.nvim

`CLAUDE_PROXY_URL`

- Optional URL override for the `claude_proxy` CodeCompanion adapter.
- Use this when work policy requires an approved Claude-compatible proxy.
- If unset, the local personal config falls back to the upstream Anthropic URL for non-work use.

`CLAUDE_PROXY_API_KEY_CMD`

- Optional command that prints an API key or short-lived token for `claude_proxy`.
- Prefer a token-printing command over storing literal tokens in config.
- If unset, the local personal config falls back to `ANTHROPIC_API_KEY` for non-work use.

`OPENAI_RESPONSES_PROXY_URL`

- Optional URL override for the OpenAI-compatible Responses API adapter used by the `openai` CodeCompanion adapter.
- Use this when work policy requires an approved OpenAI-compatible proxy for current GPT models.
- If unset, the config derives a `/responses` URL from `OPENAI_COMPAT_PROXY_URL` or `OPENAI_API_BASE`, then falls back to the upstream OpenAI Responses API URL for non-work use.

`OPENAI_COMPAT_PROXY_URL`

- Optional base or chat-completions URL used as a fallback for deriving the Responses API URL.
- If it ends in `/chat/completions`, the config rewrites that suffix to `/responses`.

`OPENAI_COMPAT_PROXY_API_KEY_CMD`

- Optional command that prints an API key or short-lived token for the OpenAI-compatible adapter.
- Prefer a token-printing command over storing literal tokens in config.
- If unset, the local personal config falls back to `PERSONAL_OPENAI_API_KEY` for non-work use.
- Avoid using workspace-injected `OPENAI_API_KEY` unless its matching base URL is also configured.

## Snacks.nvim gitbrowse

`NVIM_GITBROWSE_REMOTE_FROM`

- Optional exact git remote URL to rewrite for browser navigation.
- The Lua config escapes this with `vim.pesc`, so use the plain URL, not a Lua pattern.

`NVIM_GITBROWSE_REMOTE_TO`

- Optional replacement browser remote URL.
- This lets local clones keep one remote while `gitbrowse` opens another browser URL.

## Public-config rules

- Do not commit company-specific hostnames, repository remotes, proxy URLs, token commands, or literal tokens.
- Use generic env var names in public dotfiles.
- Keep real values in your private shell startup file or another ignored local override.
- For work docs, publish only the approved/proxied setup and omit direct-provider fallback examples.
