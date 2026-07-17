-- Minimal dotenv loader: Lua has no built-in dotenv, so parse the `.env`
-- (KEY=VALUE lines) ourselves and push values into the environment via
-- `vim.fn.setenv`, keeping every `os.getenv(...)` call working.
--
-- `~/.config/nvim/.env` is gitignored and holds machine-specific choices
-- (adapter/model, proxy URLs, keys). See `.env.sample` for the template and
-- `docs/plugins/codecompanion/env-vars.md` for what each variable does.
--
-- Precedence: a variable already exported by the shell WINS over the file.

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
