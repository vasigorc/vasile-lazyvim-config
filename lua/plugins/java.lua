return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    config = function()
      -- Find the project root directory
      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if not root_dir then
        return
      end

      -- Use a unique name for the workspace directory based on the project root.
      -- This prevents conflicts between projects.
      local workspace_dir = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local data_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. workspace_dir

      local config = {
        cmd = {
          "/Users/vasilegorcinschi/.sdkman/candidates/java/21.0.7-tem/bin/java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          vim.fn.glob("~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration",
          vim.fn.glob("~/.local/share/nvim/mason/packages/jdtls/config_mac"),
          "-data",
          data_dir, -- Use the new, unique data directory
        },
        root_dir = root_dir,
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = "/Users/vasilegorcinschi/.sdkman/candidates/java/21.0.7-tem",
                },
                {
                  name = "JavaSE-17",
                  path = "/Users/vasilegorcinschi/.sdkman/candidates/java/17.0.9-tem",
                },
                {
                  name = "JavaSE-11",
                  path = "/Users/vasilegorcinschi/.sdkman/candidates/java/11.0.20.1-tem",
                },
              },
            },
          },
        },
        init_options = {
          bundles = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          require("jdtls").start_or_attach(config)
        end,
      })
    end,
  },
  {
    "eatgrass/maven.nvim",
    cmd = { "Maven", "MavenExec" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("maven").setup({
        executable = "mvn",
      })
    end,
  },
}
