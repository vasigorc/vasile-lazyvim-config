-- Compatibility layer for using nvim-cmp sources (like nvim-metals) with blink.cmp
return {
  -- Add blink.compat for nvim-cmp sources compatibility
  {
    "saghen/blink.compat",
    version = "2.*",
    lazy = true,
    opts = {},
  },

  -- Configure blink.cmp to use nvim-cmp sources via compat layer ONLY for Scala
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "saghen/blink.compat",
      "hrsh7th/cmp-nvim-lsp", -- Keep this for metals
    },
    opts = {
      sources = {
        -- Use native blink sources by default
        default = { "lsp", "path", "snippets", "buffer" },
        -- Add nvim_lsp provider ONLY for Scala files (metals compatibility)
        per_filetype = {
          scala = { "nvim_lsp", "path", "snippets", "buffer" },
        },
        providers = {
          -- Use the compat layer to bridge nvim-cmp's cmp-nvim-lsp with blink for metals
          nvim_lsp = {
            name = "nvim_lsp",
            module = "blink.compat.source",
            score_offset = 10, -- Prioritize LSP completions
          },
        },
      },
    },
  },
}
