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
  -- TreeSitter configuration for AsciiDoc
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add asciidoc to ensure_installed
      if not opts.ensure_installed then
        opts.ensure_installed = {}
      end
      if not vim.tbl_contains(opts.ensure_installed, "asciidoc") then
        table.insert(opts.ensure_installed, "asciidoc")
      end

      -- Configure the asciidoc parser
      if not opts.parsers then
        opts.parsers = {}
      end
      opts.parsers.asciidoc = {
        install_info = {
          url = "https://github.com/cathaysia/tree-sitter-asciidoc",
          files = { "parser.c" },
          branch = "master",
          generate_requires_npm = true,
        },
        filetype = "asciidoc",
      }
    end,
    config = function()
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
          vim.opt_local.textwidth = 100
          -- Enable auto-formatting
          vim.opt_local.formatoptions:append("tcqn")
          -- Set comment format
          vim.opt_local.comments = "fb:*,fb:-,fb:.,n:>"
        end,
      })
    end,
  },
}
