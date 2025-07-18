return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
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
          vim.fn.getcwd() .. "/.workspace",
        },
        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
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
            project = {
              referencedLibraries = {
                "lib/**/*.jar",
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
}