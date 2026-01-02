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
          command = "sqlfluff",
          args = function(self, ctx)
            return { "format", "--dialect=postgres", "--nocolor", ctx.filename }
          end,
          stdin = false,
          cwd = require("conform.util").root_file({ ".git", ".sqlfluff" }),
          require_cwd = false,
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

  -- Configure sqls LSP with formatting disabled
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sqls = {
          -- Disable formatting - we use sqlfluff instead
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          settings = {
            sqls = {
              -- Enable keyword completion without database connection
              connections = {},
            },
          },
        },
      },
    },
  },
}
