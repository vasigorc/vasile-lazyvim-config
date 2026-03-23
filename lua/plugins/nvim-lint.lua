return {
  "mfussenegger/nvim-lint",
  optional = true,
  dependencies = "mason-org/mason.nvim",
  opts = {
    linters_by_ft = {
      kotlin = { "ktlint" },
      -- nix statix linter is already configured by LazyVim extras.lang.nix
      go = { "golangcilint" },
    },
  },
}
