-- Based on https://www.lazyvim.org/plugins/util
return {
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = false },
      gitbrowse = {
        config = function(opts)
          -- Keep environment-specific remote rewrites in shell env, not in Lua config.
          local remote_from = os.getenv("NVIM_GITBROWSE_REMOTE_FROM")
          local remote_to = os.getenv("NVIM_GITBROWSE_REMOTE_TO")

          if remote_from == nil or remote_from == "" or remote_to == nil or remote_to == "" then
            return
          end

          opts.remote_patterns = opts.remote_patterns or {}
          table.insert(opts.remote_patterns, 1, {
            "^" .. vim.pesc(remote_from) .. "$",
            remote_to,
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
