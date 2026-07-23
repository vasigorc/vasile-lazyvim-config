return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    config = function()
      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if not root_dir then
        return
      end

      local os_config = "config_linux"
      if vim.fn.has("mac") == 1 then
        os_config = "config_mac"
      end

      local home = vim.fn.expand("~")

      -- Feature version from JAVA_HOME/release: "17.0.19" -> 17, "1.8.0_402" -> 8.
      local function java_major(jhome)
        local fd = io.open(jhome .. "/release", "r")
        if not fd then
          return nil
        end
        local major
        for line in fd:lines() do
          local v = line:match('^JAVA_VERSION="([^"]+)"')
          if v then
            local a, b = v:match("^(%d+)%.(%d+)")
            major = (a == "1") and tonumber(b) or (tonumber(a) or tonumber(v:match("^(%d+)")))
            break
          end
        end
        fd:close()
        return major
      end

      local function javase_name(major)
        if not major then
          return nil
        end
        return (major <= 8) and ("JavaSE-1." .. major) or ("JavaSE-" .. major)
      end

      -- Extra JDK locations (Linux distro dirs, SDKMAN, tarballs); additive, deduped.
      local function extra_java_homes()
        local patterns = { home .. "/.sdkman/candidates/java/*" } -- SDKMAN, any OS
        if vim.fn.has("mac") == 1 then
          table.insert(patterns, "/Library/Java/JavaVirtualMachines/*/Contents/Home")
        else
          vim.list_extend(patterns, {
            "/usr/lib/jvm/*",
            "/usr/lib/jvm/*/Contents/Home",
            "/usr/java/*",
            "/opt/java/*",
            "/home/linuxbrew/.linuxbrew/opt/openjdk*/libexec/openjdk.jdk/Contents/Home",
          })
        end
        local out = {}
        for _, g in ipairs(patterns) do
          for _, p in ipairs(vim.fn.glob(g, true, true)) do
            table.insert(out, p)
          end
        end
        return out
      end

      -- Version is re-derived per candidate (so a wrong /usr/libexec/java_home label
      -- is corrected). Priority: $JAVA_HOME > java_home probes > Homebrew; deduped by name.
      local function discover_runtimes()
        local runtimes, by_name, seen = {}, {}, {}

        local function add(jhome)
          if not jhome or jhome == "" then
            return
          end
          if vim.fn.isdirectory(jhome) == 0 or vim.fn.executable(jhome .. "/bin/java") == 0 then
            return
          end
          local resolved = vim.fn.resolve(jhome)
          if seen[resolved] then
            return
          end
          local name = javase_name(java_major(jhome))
          if not name or by_name[name] then
            return -- unknown version, or a higher-priority JDK already claimed this name
          end
          seen[resolved], by_name[name] = true, true
          table.insert(runtimes, { name = name, path = jhome })
        end

        -- 1. Per-project JDK exported as $JAVA_HOME (e.g. by a per-project env shell)
        add(vim.env.JAVA_HOME)

        -- 2. macOS java_home probes (version re-derived, so mislabels are corrected)
        if vim.fn.has("mac") == 1 and vim.fn.executable("/usr/libexec/java_home") == 1 then
          for _, v in ipairs({ "21", "17", "11" }) do
            local out = vim.fn.system({ "/usr/libexec/java_home", "-v", v })
            if vim.v.shell_error == 0 then
              add(vim.trim(out))
            end
          end
        end

        -- 3. Homebrew versioned kegs as additional fallbacks
        for _, keg in ipairs({ "openjdk@21", "openjdk@17", "openjdk@11" }) do
          add("/opt/homebrew/opt/" .. keg .. "/libexec/openjdk.jdk/Contents/Home")
        end

        -- 4. Distro / SDKMAN / tarball JDKs (Linux + extra macOS JVMs); fills gaps.
        for _, jhome in ipairs(extra_java_homes()) do
          add(jhome)
        end

        return runtimes
      end

      local runtimes = discover_runtimes()

      -- The Gradle import daemon runs on the server JVM (21) unless pinned, but
      -- Gradle 8.2 can't run on 21 -- pin it to Java 17 ($JAVA_HOME if 17, else JavaSE-17).
      local function gradle_java_home()
        local jh = vim.env.JAVA_HOME
        if jh and jh ~= "" and java_major(jh) == 17 then
          return jh
        end
        for _, rt in ipairs(runtimes) do
          if rt.name == "JavaSE-17" then
            return rt.path
          end
        end
        return nil
      end

      -- jdtls 1.55's server is Java-21 bytecode, so the JVM running it must be >= 21.
      -- Bare "java" from a per-project env shell may be Java 17 -> exit 13. Pin to a
      -- Java 21+ (prefer 21 over newer majors like plain-openjdk 26).
      local function server_java()
        local candidates = {}
        if vim.fn.has("mac") == 1 and vim.fn.executable("/usr/libexec/java_home") == 1 then
          for _, v in ipairs({ "21", "22", "23", "24", "25" }) do
            local out = vim.fn.system({ "/usr/libexec/java_home", "-v", v })
            if vim.v.shell_error == 0 then
              table.insert(candidates, vim.trim(out))
            end
          end
        end
        table.insert(candidates, "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home")
        table.insert(candidates, "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home")
        for _, jhome in ipairs(extra_java_homes()) do
          table.insert(candidates, jhome)
        end
        for _, rt in ipairs(runtimes) do
          table.insert(candidates, rt.path)
        end
        local best
        for _, jhome in ipairs(candidates) do
          local exe = jhome .. "/bin/java"
          if vim.fn.executable(exe) == 1 then
            local m = java_major(jhome)
            -- prefer the lowest major >= 21 (i.e. 21 itself)
            if m and m >= 21 and (not best or m < best.major) then
              best = { exe = exe, major = m }
            end
          end
        end
        return best and best.exe or "java"
      end

      -- Per-project workspace dir so projects don't clash.
      local workspace_dir = vim.fn.fnamemodify(root_dir, ":t")
      local data_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. workspace_dir

      local config = {
        cmd = {
          server_java(),
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          -- Default 1g heap OOMs on this multi-module build during indexing and
          -- hangs symbol requests; bump heap + jdtls's recommended GC flags.
          "-XX:+UseParallelGC",
          "-XX:GCTimeRatio=4",
          "-XX:AdaptiveSizePolicyWeight=90",
          "-Dsun.zip.disableMemoryMapping=true",
          "-Xms256m",
          "-Xmx4g",
          -- Lombok modifies JDT's compiler AST, so annotation processing alone is not enough.
          -- Load Mason's bundled agent into the JDTLS JVM to expose generated members to the LSP.
          "-javaagent:" .. vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration",
          home .. "/.local/share/nvim/mason/packages/jdtls/" .. os_config,
          "-data",
          data_dir,
        },
        root_dir = root_dir,
        settings = {
          java = {
            configuration = {
              runtimes = runtimes,
            },
            import = {
              gradle = {
                java = {
                  home = gradle_java_home(),
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
