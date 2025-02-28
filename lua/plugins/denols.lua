return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      denols = {
        root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
        single_file_support = false,
      },
      vtsls = {
        -- Prevent vtsls from activating in Deno projects
        root_dir = function(fname)
          local util = require("lspconfig.util")
          if util.root_pattern("deno.json", "deno.jsonc")(fname) then
            return nil
          end
          return util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
        end,
      },
    },
  },
}
