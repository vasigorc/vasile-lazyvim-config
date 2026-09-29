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
        -- rustfmt directly rather than via rust-analyzer; reads the project's
        -- rustfmt.toml and the edition from Cargo.toml
        rust = { "rustfmt" },
        -- Ruby/ERB formatting
        ruby = { "rubocop" },
        eruby = { "erb_format" },
      },
    },
  },
}
