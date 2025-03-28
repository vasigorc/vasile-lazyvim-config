return {
  { "mfussenegger/nvim-dap-python", enabled = false },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    event = "VeryLazy",
    config = function()
      require("venv-selector").setup({
        -- Enable status line support
        enable_statusline = true,
        name = { "venv", "shared_venv", ".venv" },
      })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  },
}
