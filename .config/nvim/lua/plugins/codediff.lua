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
      position = "left", -- "left" or "bottom"
      width = 60, -- Width when position is "left" (columns)
      height = 15, -- Height when position is "bottom" (lines)
      indent_markers = true, -- Show indent markers in tree view (│, ├, └)
      initial_focus = "modified", -- Initial focus: "explorer", "original", or "modified"
      icons = {
        folder_closed = "", -- Nerd Font folder icon (customize as needed)
        folder_open = "", -- Nerd Font folder-open icon
      },
      view_mode = "tree", -- "list" or "tree"
      flatten_dirs = true, -- Flatten single-child directory chains in tree view
      file_filter = {
        ignore = { ".git/**", ".jj/**" }, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
      },
      focus_on_select = false, -- Jump to modified pane after selecting a file (default: stay in explorer)
      visible_groups = { -- Which groups to show (can be toggled at runtime)
        staged = true,
        unstaged = true,
        conflicts = true,
      },
    },

    -- History panel configuration (for :CodeDiff history)
    history = {
      position = "bottom", -- "left" or "bottom" (default: bottom)
      width = 40, -- Width when position is "left" (columns)
      height = 25, -- Height when position is "bottom" (lines)
      initial_focus = "history", -- Initial focus: "history", "original", or "modified"
      view_mode = "list", -- "list" or "tree" for files under commits
    },

    -- Keymaps in diff view
    keymaps = {
      view = {
        quit = "q", -- Close diff tab
        toggle_explorer = "<leader>b", -- Toggle explorer visibility (explorer mode only)
        focus_explorer = "<leader>e", -- Focus explorer panel (explorer mode only)
        next_hunk = "]c", -- Jump to next change
        prev_hunk = "[c", -- Jump to previous change
        next_file = "]f", -- Next file in explorer/history mode
        prev_file = "[f", -- Previous file in explorer/history mode
        diff_get = "do", -- Get change from other buffer (like vimdiff)
        diff_put = "dp", -- Put change to other buffer (like vimdiff)
        open_in_prev_tab = "gf", -- Open current buffer in previous tab (or create one before)
        toggle_stage = "-", -- Stage/unstage current file (works in explorer and diff buffers)
        stage_hunk = "<leader>hs", -- Stage hunk under cursor to git index
        unstage_hunk = "<leader>hu", -- Unstage hunk under cursor from git index
        discard_hunk = "<leader>hr", -- Discard hunk under cursor (working tree only)
        hunk_textobject = "ih", -- Textobject for hunk (vih to select, yih to yank, etc.)
        show_help = "g?", -- Show floating window with available keymaps
      },
      explorer = {
        select = "<CR>", -- Open diff for selected file
        hover = "K", -- Show file diff preview
        refresh = "R", -- Refresh git status
        toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
        stage_all = "S", -- Stage all files
        unstage_all = "U", -- Unstage all files
        restore = "X", -- Discard changes (restore file)
        toggle_changes = "gu", -- Toggle Changes (unstaged) group visibility
        toggle_staged = "gs", -- Toggle Staged Changes group visibility
      },
      history = {
        select = "<CR>", -- Select commit/file or toggle expand
        toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
      },
      conflict = {
        accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
        accept_current = "<leader>co", -- Accept current (ours/right) change
        accept_both = "<leader>cb", -- Accept both changes (incoming first)
        discard = "<leader>cx", -- Discard both, keep base
        next_conflict = "]x", -- Jump to next conflict
        prev_conflict = "[x", -- Jump to previous conflict
        diffget_incoming = "2do", -- Get hunk from incoming (left/theirs) buffer
        diffget_current = "3do", -- Get hunk from current (right/ours) buffer
      },
    },
  },
}
