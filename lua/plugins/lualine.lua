return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local function get_venv()
        if vim.bo.filetype ~= "python" then
          return ""
        end
        -- Try venv-selector first
        local vs = require("venv-selector")
        local venv = vs.get_active_venv and vs.get_active_venv()
        if venv then
          return "🐍 " .. vim.fn.fnamemodify(venv, ":t")
        end
        -- Fallback to environment variable
        venv = vim.env.VIRTUAL_ENV
        if venv then
          return "🐍 " .. vim.fn.fnamemodify(venv, ":t")
        end
        return ""
      end

      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, get_venv)
      return opts
    end,
  },
}
