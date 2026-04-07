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
        sorbet = {
          mason = false,
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              if result and result.uri and not result.uri:match("^%w+://") then
                result.uri = "file://" .. vim.fn.getcwd() .. "/" .. result.uri
              end
              return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
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
