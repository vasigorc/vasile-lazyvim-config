-- Minimal dotenv loader. Neovim/Lua has no built-in `dotenv` (unlike Scala or
-- Rust), but a `.env` is just KEY=VALUE lines, so we parse it ourselves and push
-- the values into the process environment via `vim.fn.setenv`. Every existing
-- `os.getenv(...)` call (e.g. in the CodeCompanion adapters) then keeps working.
--
-- The file is `~/.config/nvim/.env`, is gitignored, and holds machine-specific
-- choices (default adapter/model, proxy URLs, keys) that must NOT be committed.
-- See `.env.sample` for the documented template.
--
-- Precedence: a variable already exported by the shell WINS over the file, so a
-- machine that already exports these vars behaves exactly as before.

local M = {}

function M.load(path)
  path = path or (vim.fn.stdpath("config") .. "/.env")
  local fd = io.open(path, "r")
  if not fd then
    return false
  end

  for raw in fd:lines() do
    local line = raw:gsub("^%s+", ""):gsub("%s+$", "")
    -- skip blank lines and full-line comments
    if line ~= "" and not line:match("^#") then
      local key, value = line:match("^([%w_]+)%s*=%s*(.*)$")
      if key then
        -- strip one layer of matching surrounding quotes
        value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
        -- never clobber a value the shell already exported
        if os.getenv(key) == nil then
          vim.fn.setenv(key, value)
        end
      end
    end
  end

  fd:close()
  return true
end

return M
