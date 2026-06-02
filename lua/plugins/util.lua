-- Based on https://www.lazyvim.org/plugins/util
return {
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = false },
      gitbrowse = {
        config = function(opts)
          -- Keep the git remote as gitstream, but browse Shopify's monorepo on GitHub.
          opts.remote_patterns = opts.remote_patterns or {}
          table.insert(opts.remote_patterns, 1, {
            "^https://gitstream%.shopify%.io/shop/world%.git$",
            "https://github.com/shop/world.git",
          })
        end,
      },
      picker = {
        enabled = true,
        sources = {
          icons = {
            custom_sources = {
              github_shortcodes = vim.fn.stdpath("config") .. "/data/github-emoji-shortcodes.json",
            },
          },
        },
      },
    },
  },
}
