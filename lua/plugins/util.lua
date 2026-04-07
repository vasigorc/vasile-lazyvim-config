-- Based on https://www.lazyvim.org/plugins/util
return {
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = false },
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
