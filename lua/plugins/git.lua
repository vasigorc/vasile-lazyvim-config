return {
  -- Gitsigns for git decorations and basic git operations
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
      },
    },
  },

  -- Fugitive for advanced Git commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
      { "<leader>gP", "<cmd>Git push<cr>", desc = "Git Push" },
      { "<leader>gl", "<cmd>Git pull<cr>", desc = "Git Pull" },
      { "<leader>gm", "<cmd>Git mergetool<cr>", desc = "Git Mergetool" },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },

    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "DiffView Close" },
      -- File history for current buffer
      { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History (Current Buffer)" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
      },
    },
  },
}
