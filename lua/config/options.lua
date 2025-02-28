-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Disable Python provider warning
vim.g.loaded_python3_provider = 0
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.python_dap_enabled = false -- Disable DAP loading
vim.opt.winbar = "%=%m %f"
-- In config/options.lua
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
-- Set up regular line numbers (non-relative)
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = false -- Disable relative line numbers
-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false
