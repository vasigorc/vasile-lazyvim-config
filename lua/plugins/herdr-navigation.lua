-- Seamless <C-h/j/k/l> across Neovim splits and herdr panes.
-- https://github.com/paulbkim-dev/vim-herdr-navigation
--
-- lazy.nvim always installs the checkout, because herdr links its plugin half
-- from it:
--   herdr plugin link ~/.local/share/nvim/lazy/vim-herdr-navigation
-- The editor half only loads inside a herdr pane. Under tmux,
-- vim-tmux-navigator.lua keeps <C-h/j/k/l> exactly as before.
--
-- The keys are declared as lazy triggers, so LazyVim's default <C-h/j/k/l>
-- window maps (safe_keymap_set) back off, as they do for vim-tmux-navigator.
local in_herdr = (vim.env.HERDR_PANE_ID or "") ~= ""

return {
  "paulbkim-dev/vim-herdr-navigation",
  lazy = true,
  keys = in_herdr and {
    { "<c-h>", desc = "Navigate left (vim/herdr)" },
    { "<c-j>", desc = "Navigate down (vim/herdr)" },
    { "<c-k>", desc = "Navigate up (vim/herdr)" },
    { "<c-l>", desc = "Navigate right (vim/herdr)" },
  } or {},
  config = function(plugin)
    dofile(plugin.dir .. "/editor/nvim.lua")
  end,
}
