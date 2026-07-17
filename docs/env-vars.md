# Environment variables for Neovim

This local Neovim config keeps environment-specific endpoints and token commands
out of Lua plugin files.

Define these in your shell startup file, then restart Neovim or source the file
before launching Neovim. A gitignored `.env` in the config root is also loaded
at startup (see [`.env.sample`](../.env.sample) and `lua/config/env.lua`);
anything already exported by the shell wins over `.env`.

## CodeCompanion.nvim

CodeCompanion configuration and its environment variables have their own
reference: [`docs/plugins/codecompanion/`](plugins/codecompanion/README.md).

- [Overview + adapter table](plugins/codecompanion/README.md)
- [Environment variables](plugins/codecompanion/env-vars.md)
- [Prerequisites](plugins/codecompanion/prerequisites.md)
- [ACP adapters (Claude Code, Pi)](plugins/codecompanion/acp-support.md)

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
