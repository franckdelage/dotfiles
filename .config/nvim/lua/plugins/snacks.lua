return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@class snacks.Config
  opts = {
    animate = { enabled = true },
    bigfile = { enabled = false },
    bufdelete = { enabled = true },
    dim = {
      enabled = false,
      scope = {
        min_size = 3,
        max_size = 20,
        siblings = true,
      },
    },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    ---@class snacks.indent.Config
    indent = {
      enabled = true,
      indent = {
        enabled = true,
        only_scope = true,
      },
      scope = {
        enabled = true,
        show_end = false,
      },
    },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      formatters = {
        file = {
          filename_first = false,
          truncate = 120,
        },
      },
      actions = {
        sidekick_send = function (...)
          return require("sidekick.cli.picker.snacks").send(...)
        end,
      },
      win = {
        input = {
          keys = {
            ["<a-a>"] = {
              "sidekick_send",
              mode = { "n", "i" },
            },
          },
        },
      },
    },
    scratch = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    toggle = { },
    words = { enabled = true },
    zen = { enabled = true },
    dashboard = {
      enabled = true,
      formats = {
        key = function(item)
          return {
            { "[", hl = "special" },
            { item.key, hl = "key" },
            { "]", hl = "special" },
          }
        end,
      },
      sections = {
        { section = "header" },
        { title = "MRU", padding = 1 },
        { section = "recent_files", limit = 8, padding = 1 },
        { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
        { section = "recent_files", cwd = true, limit = 8, padding = 1 },
        { title = "Bookmarks", padding = 1 },
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = " ", key = "s", desc = "Find session", action = ":AutoSession search" },
        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    styles = {
      scratch = {
        width = 120,
        height = 35,
      },
    },
  },
  keys = {
    { "<leader>,", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    -- { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    -- { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<leader>ud", function() Snacks.dim.enable() end, desc = "Dim" },
    { "<leader>uu", function() Snacks.dim.disable() end, desc = "Undim" },
    -- find
    { "<leader>bf", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sn", function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end, desc = "Find Neovim File" },
    { "<leader>sf", function() Snacks.picker.files { hidden = true } end, desc = "Find Files" },
    { "<leader>f", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    -- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- gh
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr { state = "all" } end, desc = "GitHub Pull Requests (all)" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word({ args = { "--hidden", "--word-regexp" } }) end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "<leader>lD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>ld", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>ll", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "<leader>lt", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "<leader>lu", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "<leader>li", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bx", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
    { "<leader>ba", function() Snacks.bufdelete.all() end, desc = "Delete All Buffers" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
}
