return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "%.rbi$" },
      },
      pickers = {
        lsp_dynamic_workspace_symbols = {
          file_ignore_patterns = { "%.rbi$" },
        },
        find_files = {
          hidden = true,
          attach_mappings = function(_, map)
            map("i", "<CR>", function(bufnr)
              -- This makes telescope open the file in the current window only
              require("telescope.actions.set").edit(bufnr, "edit")
            end)
            return true
          end,
        },
      },
    },
  },
}
