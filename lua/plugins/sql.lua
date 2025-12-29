return {
  -- Update conform to use sqlfluff with PostgreSQL dialect
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqlfluff" },
      },
      formatters = {
        sqlfluff = {
          args = { "format", "--dialect=postgres", "-" },
        },
      },
    },
  },

  -- Configure vim-dadbod for database connections
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration here
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

      -- Example: Add your local PostgreSQL connections
      -- vim.g.dbs = {
      --   dev = "postgres://localhost:5432/mydb",
      --   k8s_pvc = "postgres://localhost:5432/pvc_reporter",
      -- }
    end,
  },

  -- Optional: Add sqls LSP for better SQL intelligence
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sqls = {
          -- Uncomment and configure if you install sqls
          cmd = { "sqls" },
          filetypes = { "sql", "mysql" },
        },
      },
    },
  },
}
