return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
  config = function()
    -- CodeCompanion loads its builtin prompt library (/fix, /explain, /lsp,
    -- /tests, ...) from markdown whose YAML frontmatter is parsed via the `yaml`
    -- treesitter parser. That parser is a documented prerequisite (see
    -- codecompanion's doc/installation.md). Without it, every builtin prompt is
    -- rejected with "[Prompt Library] Missing frontmatter, name or interaction"
    -- and aliases such as /fix report "Could not find `fix` in the prompt library".
    -- `yaml` is declared in nvim-treesitter's ensure_installed, but on the `main`
    -- branch a one-time parser install can be skipped, so ensure it here.
    if not pcall(vim.treesitter.get_string_parser, "a: b", "yaml") then
      local ok_ts, ts = pcall(require, "nvim-treesitter")
      if ok_ts and type(ts.install) == "function" then
        ts.install({ "yaml" }) -- async on main branch; ready on next launch
      end
    end

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
                      opts = { has_vision = true, max_tokens = 64000 },
                    },
                  },
                },
              },
              handlers = {
                -- Claude Opus 4.7/4.8 reject the legacy extended-thinking shape
                -- (`thinking = { type = "enabled", budget_tokens = N }`). The proxy
                -- requires the newer adaptive thinking API: `thinking.type = "adaptive"`
                -- plus `output_config.effort`.
                --
                -- The base adapter decides whether to attach thinking from the
                -- adapter's *default* model (Opus 4.8, can_reason), not the actual
                -- per-request model. That means non-reasoning requests (e.g. Haiku
                -- title generation) wrongly get thinking params and the proxy errors.
                -- So: gate on the resolved request model. Strip thinking entirely for
                -- non-reasoning models; rewrite to the adaptive shape otherwise.
                form_parameters = function(self, params, messages)
                  params = require("codecompanion.adapters.http.anthropic").handlers.form_parameters(
                    self,
                    params,
                    messages
                  )
                  local choices = self.schema.model.choices
                  local choice = params.model and choices and choices[params.model]
                  local model_opts = choice and choice.opts

                  -- Clamp max_tokens to the resolved model's output cap. The base
                  -- adapter sizes max_tokens from the adapter's *default* model
                  -- (Opus 4.8 -> 128000), so a per-request override to a smaller
                  -- model (e.g. Haiku title generation, cap 64000) would send
                  -- max_tokens > cap and the proxy returns HTTP 400.
                  if model_opts and model_opts.max_tokens
                    and type(params.max_tokens) == "number"
                    and params.max_tokens > model_opts.max_tokens then
                    params.max_tokens = model_opts.max_tokens
                  end

                  if type(params.thinking) == "table" then
                    if model_opts and model_opts.can_reason then
                      params.thinking = { type = "adaptive" }
                      params.output_config = vim.tbl_extend(
                        "force",
                        params.output_config or {},
                        { effort = "high" }
                      )
                    else
                      params.thinking = nil
                      params.temperature = nil
                    end
                  end
                  return params
                end,
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
                -- GPT 5.x Responses models reject sampling overrides like top_p.
                -- Mark them disabled for the picker/defaults, and the request
                -- handler below strips stale values from existing chat buffers.
                temperature = { enabled = function() return false end },
                top_p = { enabled = function() return false end },
              },
              handlers = {
                request = {
                  build_parameters = function(self, params, messages)
                    params = require("codecompanion.adapters.http.openai_responses").handlers.request.build_parameters(
                      self,
                      params,
                      messages
                    )
                    params.temperature = nil
                    params.top_p = nil
                    return params
                  end,
                },
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
