return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  keys = {
    { "<leader>gcd", "<cmd>CodeDiff<cr>", desc = "Show git diff" },
    { "<leader>gcD", "<cmd>CodeDiff HEAD~1<cr>", desc = "Show git diff against HEAD~1" },
    { "<leader>gch", "<cmd>CodeDiff history %<cr>", desc = "Show git history for current file" },
    { "<leader>gcH", "<cmd>CodeDiff history<cr>", desc = "Show git history for all files" },
  },
  opts = {
    -- Explorer panel configuration
    explorer = {
      width = 60, -- Width when position is "left" (columns)
      icons = {
        folder_closed = "", -- Nerd Font folder icon (customize as needed)
        folder_open = "", -- Nerd Font folder-open icon
      },
      view_mode = "tree", -- "list" or "tree"
      flatten_dirs = true, -- Flatten single-child directory chains in tree view
      file_filter = {
        ignore = { ".git/**", ".jj/**" }, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
      },
      visible_groups = { -- Which groups to show (can be toggled at runtime)
        staged = true,
        unstaged = true,
        conflicts = true,
      },
    },

    -- Diff view configuration
    diff = {
      cycle_hunks_across_files = true, -- Cycle through hunks across files (default: false)
    },

    -- Keymaps in diff view
    keymaps = {
      view = {
        close_on_open_in_prev_tab = false,
      },
    },
  },
}
