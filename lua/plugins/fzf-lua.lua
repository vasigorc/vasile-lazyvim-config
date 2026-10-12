return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    local lazyvim_ui_select = opts.ui_select
    if type(lazyvim_ui_select) ~= "function" then
      return
    end

    -- LazyVim sizes the code action picker as `0.8 * lines - 16 + 16`, then fzf-lua
    -- gives 15 lines (+ border) of that to the preview. On a short window or tmux
    -- pane the list gets height <= 0 and nvim_open_win fails with
    -- "Invalid 'height': expected positive Integer". Below that threshold, start
    -- with the preview hidden and size the picker by its items instead.
    opts.ui_select = function(fzf_opts, items)
      local o = lazyvim_ui_select(fzf_opts, items)
      local max_height = math.floor(vim.o.lines * 0.8)
      if fzf_opts.kind == "codeaction" and max_height < 24 then
        o.winopts.preview = vim.tbl_extend("force", o.winopts.preview or {}, { hidden = true })
        o.winopts.height = math.max(3, math.min(max_height, #items + 4))
      end
      return o
    end
  end,
}
