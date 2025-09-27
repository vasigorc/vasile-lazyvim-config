-- follow: https://github.com/LazyVim/LazyVim/issues/6039
-- This file is needed to pin the versions of mason.nvim and mason-lspconfig.nvim
-- to a compatible range due to breaking changes in recent versions.
return {
  { "mason-org/mason.nvim", version = "^2.0.1" },
  { "mason-org/mason-lspconfig.nvim", version = "^2.1.0" },
}