return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
  config = function()
    local function openai_responses_url()
      local url = os.getenv("OPENAI_RESPONSES_PROXY_URL")
      if url and url ~= "" then
        return url
      end

      url = os.getenv("OPENAI_COMPAT_PROXY_URL")
      if url and url ~= "" then
        url = url:gsub("/+$", "")
        url = url:gsub("/chat/completions$", "/responses")
        if not url:match("/responses$") then
          url = url .. "/responses"
        end
        return url
      end

      local base = os.getenv("OPENAI_API_BASE")
      if base and base ~= "" then
        url = base:gsub("/+$", "")
        if not url:match("/responses$") then
          url = url .. "/responses"
        end
        return url
      end

      return "https://api.openai.com/v1/responses"
    end

    require("codecompanion").setup({
      adapters = {
        http = {
          -- Claude via optional proxy env vars, with personal direct-provider fallback.
          claude_proxy = function()
            return require("codecompanion.adapters").extend("anthropic", {
              name = "claude_proxy",
              formatted_name = "Claude Proxy",
              url = os.getenv("CLAUDE_PROXY_URL") or "https://api.anthropic.com/v1/messages",
              env = {
                api_key = "cmd:" .. (os.getenv("CLAUDE_PROXY_API_KEY_CMD") or "echo $ANTHROPIC_API_KEY"),
              },
              schema = {
                model = {
                  default = "claude-opus-4-8",
                  choices = {
                    ["claude-opus-4-8"] = {
                      formatted_name = "Claude Opus 4.8",
                      opts = { can_reason = true, has_vision = true },
                    },
                    ["claude-opus-4-7"] = {
                      formatted_name = "Claude Opus 4.7",
                      opts = { can_reason = true, has_vision = true },
                    },
                    ["claude-opus-4-6"] = {
                      formatted_name = "Claude Opus 4.6",
                      opts = { can_reason = true, has_vision = true },
                    },
                    ["claude-sonnet-4-6"] = {
                      formatted_name = "Claude Sonnet 4.6",
                      opts = { can_reason = true, has_vision = true },
                    },
                    ["claude-haiku-4-5-20251001"] = {
                      formatted_name = "Claude Haiku 4.5",
                      opts = { has_vision = true },
                    },
                  },
                },
              }
            })
          end,
          ollama_qwen = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "ollama_qwen",
              schema = {
                model = {
                  default = "qwen2.5-coder:14b-instruct-q8_0",
                },
              },
            })
          end,
          deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              env = {
                api_key = os.getenv("DEEPSEEK_API_KEY"),
              },
            })
          end,
          openai = function()
            return require("codecompanion.adapters").extend("openai_responses", {
              name = "openai",
              formatted_name = "GPT Proxy (Responses)",
              url = openai_responses_url(),
              env = {
                api_key = "cmd:"
                  .. (os.getenv("OPENAI_COMPAT_PROXY_API_KEY_CMD") or "echo $PERSONAL_OPENAI_API_KEY"),
              },
              schema = {
                model = {
                  default = "gpt-5.5",
                  choices = {
                    ["gpt-5.5"] = {
                      formatted_name = "GPT 5.5",
                      meta = { context_window = 1050000 },
                      opts = { has_function_calling = true, has_vision = true, can_reason = true },
                    },
                    ["gpt-5.4"] = {
                      formatted_name = "GPT 5.4",
                      meta = { context_window = 1050000 },
                      opts = { has_function_calling = true, has_vision = true, can_reason = true },
                    },
                    ["gpt-5.4-mini"] = {
                      formatted_name = "GPT 5.4 Mini",
                      meta = { context_window = 400000 },
                      opts = { has_function_calling = true, has_vision = true, can_reason = true },
                    },
                    ["gpt-5.3-codex"] = {
                      formatted_name = "GPT 5.3 Codex",
                      meta = { context_window = 400000 },
                      opts = { has_function_calling = true, has_vision = true, can_reason = true },
                    },
                  },
                },
                temperature = { default = nil },
                top_p = { default = nil },
              },
            })
          end,
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = os.getenv("ANTHROPIC_API_KEY"),
              },
            })
          end,
          opts = {
            -- Avoid accidentally selecting built-in direct-provider adapters that may
            -- send workspace-issued tokens to public provider endpoints.
            show_presets = false,
          },
        },
      },
      interactions = {
        chat = { adapter = "claude_proxy" },
        inline = { adapter = "claude_proxy" },
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ",
          provider = "default",
          opts = {
            show_preset_actions = true,
            show_preset_prompts = true,
          },
        },
      },
      extensions = {
        -- gh - Open history browser
        -- sc - Save current chat manually
        -- <C-R> - Open selected chat
        -- d - Delete selected chat in normal mode
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            auto_generate_title = true,
            title_generation_opts = {
              adapter = "claude_proxy",
              model = "claude-haiku-4-5-20251001",
            },
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            picker = "telescope",
            enable_logging = false,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            auto_save = true,
            save_chat_keymap = "sc",
          },
        },
      },
    })
  end,
}
