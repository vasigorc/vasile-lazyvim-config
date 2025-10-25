return {
  "mfussenegger/nvim-dap",
  config = function(self, opts)
    local dap = require("dap")
    -- Scala part
    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
          runType = "runOrTestFile",
          --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
    }
    -- Kotlin part
    if not dap.adapters.kotlin then
      dap.adapters.kotlin = {
        type = "executable",
        command = "kotlin-debug-adapter",
        options = { auto_continue_if_many_stopped = false },
      }
    end

    dap.configurations.kotlin = {
      {
        type = "kotlin",
        request = "launch",
        name = "This file",
        -- may differ, when in doubt, whatever your project structure may be,
        -- it has to correspond to the class file located at `build/classes/`
        -- and of course you have to build before you debug
        mainClass = function()
          local root = vim.fs.find("src", { path = vim.uv.cwd(), upward = true, stop = vim.env.HOME })[1] or ""
          local fname = vim.api.nvim_buf_get_name(0)
          -- src/main/kotlin/websearch/Main.kt -> websearch.MainKt
          return fname:gsub(root, ""):gsub("main/kotlin/", ""):gsub(".kt", "Kt"):gsub("/", "."):sub(2, -1)
        end,
        projectRoot = "${workspaceFolder}",
        jsonLogFile = "",
        enableJsonLogging = false,
      },
      {
        -- Use this for unit tests
        -- First, run
        -- ./gradlew --info cleanTest test --debug-jvm
        -- then attach the debugger to it
        type = "kotlin",
        request = "attach",
        name = "Attach to debugging session",
        port = 5005,
        args = {},
        projectRoot = vim.fn.getcwd,
        hostName = "localhost",
        timeout = 2000,
      },
    }
  end,
}
