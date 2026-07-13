# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Prerequisuites

There are two approaches for installing the prerquisites. You may pick either or a combination
of both

### Requirements for manual installation

Please see installation requirements for LazyVim [here](http://www.lazyvim.org/#%EF%B8%8F-requirements).
For installation of Neovim (>= version 0.9.0) refer to their [installation guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)

#### Additional recommendations / recommendations

- [nvim](https://github.com/neovim/neovim/blob/master/INSTALL.md) 
- [lazygit](https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation)
- [rustup](https://rust-lang.org/tools/install/)
  - [Optional for Rust] Run `rustup component add rust-analyzer`
- [go](https://go.dev/doc/install)
- [pipx](https://github.com/pypa/pipx?tab=readme-ov-file#install-pipx)
- [fd](https://github.com/sharkdp/fd?tab=readme-ov-file#installation)
- [Optional: if you want to avoid errors having images in Markdown files] [imagemagick](https://imagemagick.org/script/download.php#gsc.tab=0)
- [Optional: for Scala] NeoVm will configure `metals` for you, but you will have to
  manually install `metals` when on a `*.scala` file with `:MetalsInstall`
- [Optional: for Protocol-Buffers] install [protols](https://github.com/coder3101/protols?tab=readme-ov-file#for-neovim) plugin.
  Make sure that you have `cargo` version `1.88.0` installed. This plugin requires `edition2024`. I used `rustup`'s `nightly toolchain'.
- [Optional: for Go] Install Go CI linter to avoid anoying warnings:

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

- [Optional: for SQL] Install SQL tooling for PostgreSQL-aware formatting and database connections:

```bash
# PostgreSQL-aware SQL formatter and linter
pipx install sqlfluff

# PostgreSQL client for database connections
sudo apt install postgresql-client

# Optional: SQL LSP server for enhanced intelligence
go install github.com/sqls-server/sqls@latest
```

- [Optional: for Ruby] Install Ruby via rbenv and required gems:

```bash
# Install rbenv and ruby-build (don't use apt install rbenv - it's outdated)
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Add to ~/.zshrc (or ~/.bashrc)
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc

# Install Ruby (check latest 3.4.x version with: rbenv install -l | grep ^3.4)
rbenv install 3.4.8
rbenv global 3.4.8

# Install required gems
gem install rubocop sonargraph
```

### Running inside `nix-shell`

[Nix](https://nix.dev/index.html) is a package management tool for reproducible development environments.

Make sure that you have Nix installed, by following the instruction steps [here](https://nix.dev/install-nix#install-nix).

Clone [this repository](https://github.com/vasigorc/bash-utils/tree/main) and follow README steps in
its [`nix` directory](https://github.com/vasigorc/bash-utils/tree/main/nix).

For most basic Neovim setup you may run `nvim` inside `nix-shell` like such:

```shell
~/$PATH_TO_CLONED_REPO/bash-utils/nix/dynamic-nix-shell.sh nvim
```

Then you can add more modules following `nvim` in the previous command like `python` depending on
your current project.

## How to use this setup

Make sure that you have your [prerequistes](#prerequisites) and then follow the steps from [this page](http://www.lazyvim.org/installation).

## CodeCompanion with Ollama

This LazyVim configuration integrates with [CodeCompanion.nvim](https://github.com/olimorris/codecompanion.nvim) to provide AI-powered coding assistance. By default, it is configured to use [Ollama](https://ollama.com/) with the `qwen3:14b` model, which is a cost-efficient (free) solution for local AI inference.

### Ollama Installation and Model Setup

To use CodeCompanion with Ollama, you need to install Ollama and download the `qwen3:14b` model.

**For Linux (Debian-based):**

1. **Install Ollama:**

   ```bash
   curl -fsSL https://ollama.com/install.sh | sh
   ```

2. **Download the qwen3 model:**

   ```bash
   ollama pull qwen3:14b
   ```

**For macOS:**

1. **Install Ollama:** Download the macOS application from [ollama.com/download](https://ollama.com/download) and follow the installation instructions.
2. **Download the qwen3 model:**

   ```bash
   ollama pull qwen3:14b
   ```

### Selecting the adapter and model (`.env`)

Which adapter and model CodeCompanion uses is a **per-machine** choice, so it is kept out of version control. Copy the tracked template and edit your copy:

```bash
cp .env.sample .env
```

`.env` is gitignored and loaded at startup by `lua/config/env.lua`. It is a plain `KEY=VALUE` file; anything already exported by your shell takes precedence over it. The main knobs (all optional — see `.env.sample` for the full list):

| Variable | Purpose |
| --- | --- |
| `CC_DEFAULT_ADAPTER` | Adapter for chat + inline (e.g. `deepseek`, `openai`, `ollama_qwen`, `claude_code`) |
| `CC_DEFAULT_MODEL` | Model within that adapter |
| `CC_TITLE_ADAPTER` / `CC_TITLE_MODEL` | Adapter/model for chat-history title generation |

Leaving them unset keeps the defaults defined in `lua/plugins/codecompanion.lua`. Adapters that talk to a paid API still need their key exported (e.g. `DEEPSEEK_API_KEY`, `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`) — keep those in your shell (e.g. `~/.zshrc`), not in the repo.

### Optional: Claude Code via ACP

CodeCompanion can also talk to Claude models through the [Agent Client Protocol](https://agentclientprotocol.com/), driving the Claude Code CLI as a subprocess instead of calling an HTTP endpoint. The appeal: it runs against a **Claude Pro/Max subscription** rather than consuming pay-as-you-go API credits.

This is an **optional dependency** — only needed if you want to use the `claude_code` adapter. Everything else works without it.

```bash
npm i -g @agentclientprotocol/claude-agent-acp
```

Requirements and caveats:

- Requires the [Claude Code CLI](https://github.com/anthropics/claude-code), already logged in (`claude`).
- Claude Code treats `ANTHROPIC_API_KEY` as **taking precedence over your claude.ai login**. If that variable is exported in your shell, Neovim passes it down and the agent bills pay-as-you-go API credits instead of the subscription (failing with `Credit balance is too low` when the API account is empty). The adapter therefore launches the bridge with that key stripped from its environment; the HTTP adapters still receive it.
- The bridge is a Node script (`#!/usr/bin/env node`, Node >= 22), so **Node must be on the `PATH` that Neovim inherits**. If it is not (a common surprise with `nvm`), set `CC_CLAUDE_ACP_CMD` in `.env` to an absolute path or a wrapper script.
- **ACP drives the chat interaction only.** CodeCompanion's inline interaction and title generation both require an HTTP adapter. If you set `CC_DEFAULT_ADAPTER=claude_code`, those fall back to an HTTP adapter automatically; use `CC_INLINE_ADAPTER` / `CC_TITLE_ADAPTER` to point them at a provider you have credit with.

You do not have to make it the default: leave `CC_DEFAULT_ADAPTER` as-is and simply switch to *Claude Code* from the adapter picker inside a chat buffer.
