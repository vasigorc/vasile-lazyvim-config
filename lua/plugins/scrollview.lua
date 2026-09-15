-- nvim-scrollview: interactive vertical scrollbar with signs.
--
-- Theme safety notes:
--   * Most sign groups intentionally keep the plugin's default links, which
--     already point at groups catppuccin themes (DiagnosticSign*, Directory,
--     Identifier, Constant, LineNr). Overriding those would fight the theme.
--   * The handful of groups overridden below are the ones whose stock link
--     reads badly under catppuccin (see `apply_highlights`). Their colors are
--     pulled from the *active* catppuccin palette at `ColorScheme` time, so
--     switching flavour (macchiato <-> latte) stays consistent, and switching
--     away from catppuccin entirely falls back to the plugin's own defaults.
--   * Git hunk signs come from `scrollview.contrib.gitsigns`, which reuses
--     gitsigns' own highlights and symbols -- already catppuccin-themed.

---Palette for the active catppuccin flavour, or nil if catppuccin isn't active.
---@return table|nil
local function catppuccin_palette()
  if not (vim.g.colors_name or ""):match("^catppuccin") then
    return nil
  end

  local ok, palettes = pcall(require, "catppuccin.palettes")
  if not ok then
    return nil
  end

  -- No argument: resolves to the flavour catppuccin is currently using.
  local resolved, palette = pcall(palettes.get_palette)
  if not resolved or type(palette) ~= "table" or type(palette.surface2) ~= "string" then
    return nil
  end

  return palette
end

local function apply_highlights()
  local set = function(group, spec)
    vim.api.nvim_set_hl(0, group, spec)
  end

  local p = catppuccin_palette()

  if not p then
    -- `:colorscheme` clears `highlight default link`, which is how the plugin
    -- registers its defaults at load time. Re-establish the ones touched below
    -- so a non-catppuccin theme never ends up with unstyled scrollbar signs.
    set("ScrollView", { link = "Visual" })
    set("ScrollViewRestricted", { link = "CurSearch" })
    set("ScrollViewHover", { link = "CurSearch" })
    set("ScrollViewSearch", { link = "NonText" })
    set("ScrollViewConflictsTop", { link = "DiffAdd" })
    set("ScrollViewConflictsMiddle", { link = "DiffAdd" })
    set("ScrollViewConflictsBottom", { link = "DiffAdd" })
    for _, keyword in ipairs({ "Fix", "Hack", "Todo", "Warn", "Xxx" }) do
      set("ScrollViewKeywords" .. keyword, { link = "ColorColumn" })
    end
    return
  end

  -- Bar. Stock link is `Visual`, which makes the bar indistinguishable from a
  -- visual selection under catppuccin. One step brighter keeps it readable.
  set("ScrollView", { bg = p.surface2 })
  set("ScrollViewRestricted", { bg = p.overlay0 })
  set("ScrollViewHover", { bg = p.overlay2 })

  -- Search. Stock link is `NonText` (overlay0) -- too dim to spot at a glance.
  set("ScrollViewSearch", { fg = p.sky, bold = true })

  -- Keywords. Stock link is `ColorColumn`, a background-only group, so the
  -- sign text renders with no foreground of its own. Mirror todo-comments.
  set("ScrollViewKeywordsFix", { fg = p.red })
  set("ScrollViewKeywordsHack", { fg = p.peach })
  set("ScrollViewKeywordsTodo", { fg = p.blue })
  set("ScrollViewKeywordsWarn", { fg = p.yellow })
  set("ScrollViewKeywordsXxx", { fg = p.red })

  -- Conflicts. All three stock links are `DiffAdd`, so ours/base/theirs are
  -- the same green. Split them so a conflict reads directionally.
  set("ScrollViewConflictsTop", { fg = p.green })
  set("ScrollViewConflictsMiddle", { fg = p.yellow })
  set("ScrollViewConflictsBottom", { fg = p.sapphire })
end

return {
  "dstein64/nvim-scrollview",
  event = "LazyFile",
  -- gitsigns must be configured before `contrib.gitsigns.setup()` runs, since
  -- that module reads symbols and highlights out of the gitsigns config.
  dependencies = { "lewis6991/gitsigns.nvim" },
  keys = {
    { "<leader>uv", "<cmd>ScrollViewToggle<cr>", desc = "Toggle Scrollview" },
  },
  opts = {
    -- Only the focused window. Keeps redraw cost down with splits, and avoids
    -- a wall of bars in diffview / neo-tree layouts.
    current_only = true,

    signs_on_startup = { "diagnostics", "search", "marks", "conflicts", "keywords" },
    diagnostics_severities = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },

    -- Get out of the way of floats: noice, blink.cmp menus, lspsaga, and
    -- image.nvim previews all draw where the bar would otherwise sit.
    hide_on_float_intersect = true,

    -- Less churn while typing (also calmer alongside mini-animate's scroll).
    signs_hidden_for_insert = { "all" },

    -- termguicolors is on, so `winblend_gui` is the effective knob and
    -- `winblend` is ignored. Opaque keeps the bar exactly the palette color
    -- set above, and avoids blend artifacts over image.nvim output in tmux.
    winblend_gui = 0,

    excluded_filetypes = {
      "neo-tree",
      "trouble",
      "codecompanion",
      "dbui",
      "dbout",
      "lazy",
      "mason",
      "snacks_dashboard",
      "snacks_picker_list",
      "snacks_picker_preview",
      "snacks_notif",
      "snacks_terminal",
    },
  },
  config = function(_, opts)
    require("scrollview").setup(opts)

    -- Git hunk signs are not built in; they live in contrib.
    local ok, gitsigns_signs = pcall(require, "scrollview.contrib.gitsigns")
    if ok then
      gitsigns_signs.setup({ only_first_line = true })
    end

    apply_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("scrollview_catppuccin", { clear = true }),
      desc = "Re-derive nvim-scrollview highlights from the active palette",
      callback = apply_highlights,
    })
  end,
}
