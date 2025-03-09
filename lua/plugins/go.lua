return {
  -- Customize formatter for Go files
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofmt" },
      },
      formatters = {
        gofmt = {
          prepend_args = { "-s" },
        },
      },
    },
  },

  -- Override treesitter indentation for Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.indent then
        opts.indent.enable = true
      end
    end,
  },

  -- Configure gopls settings
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              usePlaceholders = true,
              completeUnimported = true,
              matcher = "fuzzy",
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
    },
  },

  -- Set up indent settings for Go files specifically
  {
    "LazyVim/LazyVim",
    opts = {
      autocmds = {
        go_indent = {
          { "FileType", {
            pattern = "go",
            callback = function()
              vim.bo.tabstop = 8
              vim.bo.shiftwidth = 4
              vim.bo.expandtab = false
              vim.bo.softtabstop = 4
            end,
          } },
        },
      },
    },
  },
}
