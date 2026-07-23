return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "saghen/blink.cmp",
    },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter emulators" },
      { "<leader>Fl", "<cmd>FlutterReload<cr>", desc = "Flutter reload" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter restart" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter outline" },
      { "<leader>Ft", "<cmd>FlutterDevTools<cr>", desc = "Start Flutter DevTools" },
      { "<leader>FO", "<cmd>FlutterOpenDevTools<cr>", desc = "Open Flutter DevTools" },
    },
    config = function()
      require("flutter-tools").setup {
        debugger = {
          enabled = true,
          exception_breakpoints = {},
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          enabled = true,
        },
        lsp = {
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            enableSnippets = true,
            updateImportsOnRename = true,
            renameFilesWithClasses = "prompt",
          },
        },
      }
    end,
  },
}
