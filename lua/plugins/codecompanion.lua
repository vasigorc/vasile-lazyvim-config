return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        http = {
          -- Shopify-proxified Claude (opus, sonnet, haiku)
          shopify_claude = function()
            return require("codecompanion.adapters").extend("anthropic", {
              name = "shopify_claude",
              formatted_name = "Shopify Claude",
              url = os.getenv("SHOPIFY_CLAUDE_URL") or "https://api.anthropic.com/v1/messages",
              env = {
                api_key = "cmd:" .. (os.getenv("SHOPIFY_CLAUDE_API_KEY_CMD") or "echo $ANTHROPIC_API_KEY"),
              },
              schema = {
                model = {
                  default = "claude-sonnet-4-6",
                  choices = {
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
              },
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
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = os.getenv("OPENAI_API_KEY"),
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
        },
      },
      interactions = {
        chat = { adapter = "shopify_claude" },
        inline = { adapter = "shopify_claude" },
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
