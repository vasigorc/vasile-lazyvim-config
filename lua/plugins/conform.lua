return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sql_formatter" },
        xml = { "xmllint" },
        -- need to install it first, on MacOS: brew install google-java-format
        java = { "google-java-format" },
        kotlin = { "ktlint" },
        nix = { "nixfmt" },
      },
    },
  },
}
