# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Prerequisuites

There are two approaches for installing the prerquisites. You may pick either or a combination
of both

### Requirements for manual installation

Please see installation requirements for LazyVim [here](http://www.lazyvim.org/#%EF%B8%8F-requirements).
For installation of Neovim (>= version 0.9.0) refer to their [installation guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)

#### Additional recommendations / recommendations:

The link above mentions `lazygit` as an optional requirement. Since it makes working
with Git in Neovim so much easier and joyful, I'd recommend to install be it manually
or as a Nix package (as part of your Nix set-up).

- [Optional: for Scala] NeoVm will configure `metals` for you, but you will have to
  manually install `metals` when on a `*.scala` file with `:MetalsInstall`

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
