# CodeCompanion prerequisites

## Treesitter `yaml` parser (required)

CodeCompanion loads its built-in prompt library (`/fix`, `/explain`, `/lsp`,
`/tests`, ...) from markdown whose YAML frontmatter is parsed by the treesitter
`yaml` parser (a documented CodeCompanion prerequisite). Without it, every
built-in prompt is rejected with:

```
[Prompt Library] Missing frontmatter, name or interaction
```

and aliases such as `/fix` report `Could not find 'fix' in the prompt library`.

`yaml` is declared in nvim-treesitter's `ensure_installed`, but on the `main`
branch a one-time parser install can be skipped, so the config installs it
defensively at startup if it is missing. No action needed in normal use.

## Node.js (only for the ACP adapters)

The `claude_code` and `pi` adapters spawn node-based bridge scripts. `node` must
be on the PATH that Neovim inherits. If you launch Neovim from a shell where a
version manager (nvm, etc.) has not been sourced, either fix the PATH or point
the relevant `CC_*_ACP_CMD` at an absolute path or a wrapper that loads node.

## Optional: Claude Code over ACP

Needed only if you set `CC_DEFAULT_ADAPTER=claude_code` or pick "Claude Code" in
the adapter picker.

```sh
pnpm add -g @agentclientprotocol/claude-agent-acp   # or: npm i -g ...
```

Plus the Claude Code CLI itself, logged in to a Claude Pro/Max subscription.
See [acp-support.md](acp-support.md) for the billing model.

## Optional: Pi over ACP

Needed only if you set `CC_DEFAULT_ADAPTER=pi` or pick "Pi" in the picker.

```sh
pnpm add -g pi-acp        # or: npm i -g pi-acp
```

The bridge just spawns whatever `pi` is on PATH — it does not bundle it. Install
the `pi` CLI separately (a system/Nix package, or
`npm i -g @earendil-works/pi-coding-agent`) and make sure it is provider-configured.

> Some environments block global `npm`. `pnpm add -g` is the drop-in
> replacement; the pnpm global bin dir must be on your PATH.
