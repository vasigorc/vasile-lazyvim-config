-- TreeSitter Textobjects configuration
-- Fix: Override LazyVim's check to force-enable textobjects for Go and other languages
-- Date: 2025-10-10

return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "c",
      "bash",
      "html",
      "wit",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      "go",
      "hocon",
      "go",
      "ron",
      "ruby",
      "rust",
      "go",
      "gomod",
      "gowork",
      "gosum",
    },
  },
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      config = function()
        -- Wait for the plugin to actually load, then set up keymaps
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("manual_textobjects", { clear = true }),
          pattern = { "go", "rust", "python", "javascript", "typescript", "lua", "java", "scala" },
          callback = function(ev)
            -- Wait a bit for lazy loading, then set up keymaps
            vim.defer_fn(function()
              vim.treesitter.start(ev.buf)
              local ok, ts_move = pcall(require, "nvim-treesitter-textobjects.move")
              if not ok then
                return
              end

              local opts = { buffer = ev.buf, silent = true }

              -- Next/previous function start
              vim.keymap.set({ "n", "x", "o" }, "]f", function()
                ts_move.goto_next_start("@function.outer")
              end, vim.tbl_extend("force", opts, { desc = "Next function start" }))

              vim.keymap.set({ "n", "x", "o" }, "[f", function()
                ts_move.goto_previous_start("@function.outer")
              end, vim.tbl_extend("force", opts, { desc = "Prev function start" }))

              -- Next/previous function end
              vim.keymap.set({ "n", "x", "o" }, "]F", function()
                ts_move.goto_next_end("@function.outer")
              end, vim.tbl_extend("force", opts, { desc = "Next function end" }))

              vim.keymap.set({ "n", "x", "o" }, "[F", function()
                ts_move.goto_previous_end("@function.outer")
              end, vim.tbl_extend("force", opts, { desc = "Prev function end" }))

              -- Next/previous parameter start
              vim.keymap.set({ "n", "x", "o" }, "]a", function()
                ts_move.goto_next_start("@parameter.inner")
              end, vim.tbl_extend("force", opts, { desc = "Next parameter start" }))

              vim.keymap.set({ "n", "x", "o" }, "[a", function()
                ts_move.goto_previous_start("@parameter.inner")
              end, vim.tbl_extend("force", opts, { desc = "Prev parameter start" }))

              -- Next/previous parameter end
              vim.keymap.set({ "n", "x", "o" }, "]A", function()
                ts_move.goto_next_end("@parameter.inner")
              end, vim.tbl_extend("force", opts, { desc = "Next parameter end" }))

              vim.keymap.set({ "n", "x", "o" }, "[A", function()
                ts_move.goto_previous_end("@parameter.inner")
              end, vim.tbl_extend("force", opts, { desc = "Prev parameter end" }))

              -- Next/previous class start
              vim.keymap.set({ "n", "x", "o" }, "]c", function()
                ts_move.goto_next_start("@class.outer")
              end, vim.tbl_extend("force", opts, { desc = "Next class start" }))

              vim.keymap.set({ "n", "x", "o" }, "[c", function()
                ts_move.goto_previous_start("@class.outer")
              end, vim.tbl_extend("force", opts, { desc = "Prev class start" }))

              -- Next/previous class end
              vim.keymap.set({ "n", "x", "o" }, "]C", function()
                ts_move.goto_next_end("@class.outer")
              end, vim.tbl_extend("force", opts, { desc = "Next class end" }))

              vim.keymap.set({ "n", "x", "o" }, "[C", function()
                ts_move.goto_previous_end("@class.outer")
              end, vim.tbl_extend("force", opts, { desc = "Prev class end" }))
            end, 100) -- 100ms delay to ensure plugin is loaded
          end,
        })
      end,
    },
  },
}

--[[
ENABLED FOR LANGUAGES: go, rust, python, javascript, typescript, lua, java, scala

NAVIGATION SHORTCUTS:
  ]f / [f - Next/previous function start
  ]F / [F - Next/previous function end
  ]a / [a - Next/previous parameter start
  ]A / [A - Next/previous parameter end
  ]c / [c - Next/previous class start
  ]C / [C - Next/previous class end

ROLLBACK:
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "c", "bash", "html", "wit", "javascript", "json", "lua",
      "markdown", "markdown_inline", "python", "query", "regex",
      "tsx", "typescript", "vim", "yaml", "go", "hocon",
    },
  },
}
--]]
