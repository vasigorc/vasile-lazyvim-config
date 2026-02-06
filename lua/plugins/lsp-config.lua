return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configure protols to only handle .proto files
        protols = {
          filetypes = { "proto" },
        },
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp" },
        },
        nil_ls = {},
        ruby_lsp = {
          mason = false,
        },
      },
    },
  },

  -- Ensure the necessary tools are installed through Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "eslint-lsp",
        "prettier",
        "protols",
      })
    end,
  },
}
