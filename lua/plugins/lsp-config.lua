return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Add any additional tsserver settings here
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
    },
    config = function()
      require("lspconfig").buf_ls.setup({
        cmd = { "buf", "beta", "lsp", "--timeout", "0", "--log-format=text" },
        filetypes = { "proto" },
        root_dir = require("lspconfig.util").root_pattern("buf.yaml", ".git"),
      })
    end,
  },

  -- Ensure the necessary tools are installed through Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "eslint-lsp", -- ESLint LSP
        "prettier", -- Prettier formatter
      })
    end,
  },
}
