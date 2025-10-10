-- Neo-tree configuration
-- Fix for yank issues on Ubuntu 24.04
-- Date: 2025-10-10
--
-- ISSUE SUMMARY:
-- - Neo-tree's default yank (y/Y) shows notification but doesn't copy to any register
-- - Affects Ubuntu 24.04 specifically (same config works on macOS)
-- - Tried both xclip and xsel - neither fixes the default behavior
-- - NeoVim clipboard detection works fine (:checkhealth shows OK)
-- - Regular yanking in buffers works correctly
--
-- ROOT CAUSE: Unknown - appears to be Ubuntu 24.04 specific interaction
-- between neo-tree and clipboard providers
--
-- SOLUTION: Manual implementation of yank mappings that directly set registers

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      window = {
        mappings = {
          -- Override the default 'y' mapping with a working implementation
          ["y"] = {
            function(state)
              local node = state.tree:get_node()
              local filename = node.name
              
              -- Manually set the registers
              vim.fn.setreg('"', filename)  -- Default register
              vim.fn.setreg('+', filename)  -- System clipboard
              vim.fn.setreg('*', filename)  -- Selection clipboard (X11)
              
              vim.notify("Yanked: " .. filename, vim.log.levels.INFO)
            end,
            desc = "Copy filename to clipboard",
          },
          
          -- Also fix 'Y' for full path
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              
              -- Manually set the registers
              vim.fn.setreg('"', filepath)  -- Default register
              vim.fn.setreg('+', filepath)  -- System clipboard
              vim.fn.setreg('*', filepath)  -- Selection clipboard (X11)
              
              vim.notify("Yanked path: " .. filepath, vim.log.levels.INFO)
            end,
            desc = "Copy filepath to clipboard",
          },
        },
      },
    },
  },
}

--[[
ROLLBACK INSTRUCTIONS:
To revert to default neo-tree behavior, replace the entire content of this file with:
return {}

DEBUGGING HISTORY:
- Confirmed xclip installed and working (:checkhealth shows OK)
- Tried switching to xsel - same issue persists
- Neo-tree shows "Copied X to clipboard" notification but nothing is in registers
- Regular vim yanking (yy, y$, etc) works perfectly
- clipboard=unnamedplus is set correctly
- Issue does NOT occur on macOS with identical config

POSSIBLE FUTURE INVESTIGATIONS:
1. Check neo-tree version/commit for known bugs
2. Try different neo-tree backends
3. Monitor neo-tree issues on GitHub for Ubuntu 24.04 reports
4. Check if AppArmor or other security policies are blocking clipboard access
--]]
