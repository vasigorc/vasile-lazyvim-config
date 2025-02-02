return {
  { "mfussenegger/nvim-dap-python", enabled = false },
  -- Dedicated venv-selector configuration
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("venv-selector").setup({
        -- Enable status line support
        enable_statusline = true,
        search = {
          "venv",
          "shared_venv",
          ".venv",
          "env",
          ".env",
        },
      })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  },
}
