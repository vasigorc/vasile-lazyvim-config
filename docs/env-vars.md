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
