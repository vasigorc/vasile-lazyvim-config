-- Inside herdr (HERDR_PANE_ID set) <C-h/j/k/l> belong to herdr-navigation.lua.
-- Keyed off HERDR_PANE_ID, not TMUX: a herdr server started from a tmux pane
-- leaks TMUX into its panes. Everywhere else (tmux, plain terminal) this spec
-- is unchanged.
local in_herdr = (vim.env.HERDR_PANE_ID or "") ~= ""

local keys = {
  { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
}
if not in_herdr then
  vim.list_extend(keys, {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
  })
end

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = keys,
}
