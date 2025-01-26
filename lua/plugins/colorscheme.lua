return {
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe", -- lattee, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        integrations = {
          mason = true,
          mini = true,
          leap = true,
          telescope = true,
          which_key = true,
          notify = true,
          noice = true,
          -- Add other integrations as needed
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
