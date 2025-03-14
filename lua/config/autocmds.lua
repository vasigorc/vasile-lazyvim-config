-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autocmd = vim.api.nvim_create_autocmd

-- Language specific indentation
autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = false
    vim.bo.softtabstop = 4
  end,
})

-- Create a named augroup for our merge conflict settings
local merge_conflict_group = vim.api.nvim_create_augroup("MergeConflictConfig", { clear = true })

-- Set up diff view enhancements
autocmd("BufReadPost", {
  group = merge_conflict_group,
  pattern = "*",
  callback = function()
    -- Check if this is a diff view (for merge conflicts)
    if vim.wo.diff then
      local buf = vim.api.nvim_get_current_buf()

      -- Map <leader>h to accept change from the left (local)
      vim.api.nvim_set_keymap("n", "<leader>hl", "<cmd>diffget LO<cr>", { noremap = true, silent = true })

      -- Map <leader>l to accept change from the right (remote)
      vim.api.nvim_set_keymap("n", "<leader>hr", "<cmd>diffget RE<cr>", { noremap = true, silent = true })

      -- Add zz to center the view after navigating through conflicts
      vim.keymap.set("n", "]c", "]czz", { buffer = buf, desc = "Next conflict and center" })
      vim.keymap.set("n", "[c", "[czz", { buffer = buf, desc = "Previous conflict and center" })

      -- Show a notification to help users
      vim.notify("Diff mode active. Use <leader>hl/hr", vim.log.levels.INFO)
    end
  end,
})

-- Add notification when opening files with conflict markers
autocmd("BufReadPost", {
  group = merge_conflict_group,
  pattern = "*",
  callback = function()
    if vim.fn.search("^<<<<<<< ", "nw") > 0 then
      vim.notify("Git conflicts found in this file. Use :diffthis to start diff mode.", vim.log.levels.WARN)
    end
  end,
})
