-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autocmd = vim.api.nvim_create_autocmd

-- Language specific indentation
autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = false
    vim.bo.softtabstop = 4
  end,
})

-- Disable auto-formatting for .env files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.env" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Set ft=hocon for files in resources/
local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })
autocmd({ "BufNewFile", "BufRead" }, {
  group = hocon_group,
  pattern = "*.conf",
  command = "set ft=hocon",
})

-- Restore :LspLog removed in Neovim 0.12
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("edit " .. vim.lsp.get_log_path())
end, { desc = "Open LSP log file" })

-- Recover from stale RuboCop LSP server cache when GEM_HOME hash rotates (dev/nix-shell)
local rubocop_cache_guard = vim.api.nvim_create_augroup("rubocop_cache_guard", { clear = true })

local function ruby_project_root()
  local gemfile = vim.fs.find("Gemfile", { upward = true, path = vim.fn.getcwd() })[1]
  return gemfile and vim.fs.dirname(gemfile) or nil
end

local function rubocop_server_cache_dir(root)
  local key = root:gsub("^/", ""):gsub("/", "+")
  return string.format("%s/tmp/rubocop/rubocop_cache/server/%s", root, key)
end

local function clear_stale_rubocop_cache()
  local root = ruby_project_root()
  local gem_home = vim.env.GEM_HOME
  if not root or not gem_home then
    return
  end

  local server_dir = rubocop_server_cache_dir(root)
  local stderr_file = server_dir .. "/stderr"
  if vim.fn.filereadable(stderr_file) == 0 then
    return
  end

  local line = (vim.fn.readfile(stderr_file, "", 1)[1] or "")
  local stale_config = line:match("Configuration file not found:") and line:match("rubocop%-shopify")
  if not stale_config or line:find(gem_home, 1, true) then
    return
  end

  local pid_file = server_dir .. "/pid"
  if vim.fn.filereadable(pid_file) == 1 then
    local pid = (vim.fn.readfile(pid_file, "", 1)[1] or ""):match("^%s*(%d+)%s*$")
    if pid then
      local cmd = vim.fn.system({ "ps", "-p", pid, "-o", "command=" })
      if cmd:match("rubocop %-%-lsp") and cmd:find(root, 1, true) then
        vim.fn.system({ "kill", pid })
      end
    end
  end

  vim.fn.delete(server_dir, "rf")
  vim.notify("Cleared stale RuboCop LSP cache for current project", vim.log.levels.INFO)
end

autocmd({ "VimEnter", "DirChanged" }, {
  group = rubocop_cache_guard,
  callback = clear_stale_rubocop_cache,
})