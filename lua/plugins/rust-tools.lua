return {
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = function()
      return {
        tools = {
          -- Configure how to format Rust code
          formatter = {
            -- Use rustfmt
            command = "rustfmt",
            -- Setup rustfmt options like edition
            options = {
              -- edition = "2021",
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },

  -- Ensure null-ls knows about rustfmt
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.rustfmt)
    end,
  },

  -- Make sure conform.nvim also uses rustfmt
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
}
