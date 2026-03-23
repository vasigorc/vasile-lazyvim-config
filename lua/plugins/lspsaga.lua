return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    keys = {
      { "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", desc = "Incoming Calls" },
      { "<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Outgoing Calls" },
    },
    opts = {
      -- Uncomment to disable lspsaga's winbar breadcrumbs (restores the global
      -- vim.opt.winbar = "%=%m %f" from options.lua, showing the peach file path).
      -- When enabled, lspsaga overrides the winbar per-window on LspAttach.
      -- symbol_in_winbar = {
      --   enable = false,
      -- },
    },
  },
}
