require("lspconfig").protols.setup({})
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
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp" }, -- explicitly omitting .proto
        },
        metals = {
          filetypes = { "scala", "sbt" },
        },
      },
    },
  },

  -- Ensure the necessary tools are installed through Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "eslint-lsp", -- ESLint LSP
        "prettier", -- Prettier formatter
        "protols", -- Protobuf support
        "sql-formatter", -- https://github.com/sql-formatter-org/sql-formatter
      })
    end,
  },
}
