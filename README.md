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

The link above mentions `lazygit` as an optional requirement. Since it makes working
with Git in Neovim so much easier and joyful, I'd recommend to install be it manually
or as a Nix package (as part of your Nix set-up).

- [Optional: for Scala] NeoVm will configure `metals` for you, but you will have to
  manually install `metals` when on a `*.scala` file with `:MetalsInstall`
- [Optional: for Protocol-Buffers] install [protols](https://github.com/coder3101/protols?tab=readme-ov-file#for-neovim) plugin.
  Make sure that you have `cargo` version `1.88.0` installed. This plugin requires `edition2024`. I used `rustup`'s `nightly toolchain'.
- [Optional: for Go] Install Go CI linter to avoid anoying warnings:

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
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

### Switching to Other Models

The default model for CodeCompanion is `qwen3:14b` due to its cost-effectiveness. However, you can easily switch to other models supported by Ollama or other adapters (e.g., OpenAI, DeepSeek, Anthropic) by modifying the `lua/plugins/codecompanion.lua` file.

To change the default model for Ollama, locate the `ollama_qwen` adapter definition and modify the `model` field:

```lua
        ollama_qwen = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "ollama_qwen",
            schema = {
              model = {
                default = "qwen3:14b", -- Change 'qwen3:14b' to your desired Ollama model
              },
            },
          })
        end,
```

To switch to a different adapter (e.g., OpenAI), you would modify the `interactions` section:

```lua
      interactions = {
        chat = { adapter = "openai" }, -- Change 'ollama_qwen' to 'openai' or another configured adapter
        inline = { adapter = "openai" },
        agent = { adapter = "deepseek" },
      },
```

Remember to set the corresponding API key as an environment variable if you are using a paid service like OpenAI, DeepSeek, or Anthropic. For example, for OpenAI, set `OPENAI_API_KEY`.
