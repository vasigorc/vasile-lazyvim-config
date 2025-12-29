return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- SQL formatting moved to lua/plugins/sql.lua
        xml = { "xmllint" },
        -- need to install it first, on MacOS: brew install google-java-format
        java = { "google-java-format" },
        kotlin = { "ktlint" },
        nix = { "nixfmt" },
      },
    },
  },
}
