return {
  -- AsciiDoc Preview plugin
  {
    "tigion/nvim-asciidoc-preview",
    ft = { "asciidoc" },
    build = "cd server && npm install",
    config = function()
      require("asciidoc-preview").setup({
        server = {
          converter = "js",
          port = 11235,
        },
        preview = {
          position = "current",
        },
      })
    end,
    keys = {
      { "<leader>ap", "<cmd>AsciiDocPreview<cr>", desc = "Preview AsciiDoc" },
      { "<leader>as", "<cmd>AsciiDocPreviewStop<cr>", desc = "Stop AsciiDoc Preview" },
      { "<leader>ao", "<cmd>AsciiDocPreviewOpen<cr>", desc = "Open AsciiDoc Preview" },
    },
  },
  -- TreeSitter configuration - combined into a single block
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      parser_install_dir = vim.fn.stdpath("data") .. "/treesitter-parser",
    },
    config = function(_, opts)
      -- Add parser_install_dir to rtp
      vim.opt.rtp:append(opts.parser_install_dir)

      -- Setup TreeSitter
      require("nvim-treesitter.configs").setup(opts)

      -- Configure AsciiDoc parser
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.asciidoc = {
        install_info = {
          url = "https://github.com/cathaysia/tree-sitter-asciidoc",
          files = { "parser.c" }, -- Changed from src/parser.c
          branch = "master",
          generate_requires_npm = true,
        },
        filetype = "asciidoc",
      }

      -- File type detection
      vim.filetype.add({
        extension = {
          adoc = "asciidoc",
          asciidoc = "asciidoc",
        },
      })

      -- AsciiDoc-specific settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "asciidoc" },
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
          vim.opt_local.conceallevel = 2
          -- Add syntax settings
          vim.opt_local.syntax = "asciidoc"
          -- Set textwidth for better formatting
          vim.opt_local.textwidth = 80
          -- Enable auto-formatting
          vim.opt_local.formatoptions:append("tcqn")
          -- Set comment format
          vim.opt_local.comments = "fb:*,fb:-,fb:.,n:>"
        end,
      })
    end,
  },
}
