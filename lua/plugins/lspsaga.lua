return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    keys = {
      { "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", desc = "Incoming Calls" },
      { "<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Outgoing Calls" },
    },
    opts = {},
  },
}
