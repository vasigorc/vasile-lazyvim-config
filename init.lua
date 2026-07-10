-- load machine-local .env (gitignored) before anything reads os.getenv(...)
pcall(function()
  require("config.env").load()
end)

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
