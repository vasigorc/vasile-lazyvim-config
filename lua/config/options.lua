-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Disable Python provider warning
vim.g.loaded_python3_provider = 0
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.python_dap_enabled = false -- Disable DAP loading
vim.opt.winbar = "%=%m %f"
