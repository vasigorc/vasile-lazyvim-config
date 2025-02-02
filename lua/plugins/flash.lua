return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- Keep the useful features of Flash
    modes = {
      char = {
        -- Specify only the character movements you want
        -- f = forward, F = backward, t = forward till, T = backward till
        keys = { "f", "F", "t", "T" },
      },
      search = {
        -- Enable enhanced / search
        enabled = true,
      },
    },
  },
  -- Remove the S mapping but keep other default Flash.nvim mappings
  keys = {
    { "S", mode = { "n", "x", "o" }, false },
  },
}
