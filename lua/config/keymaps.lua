-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Snacks icon picker
vim.keymap.set("n", "<leader>si", function()
  require("snacks").picker.icons()
end, { desc = "Icons" })
