return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require('copilot').setup({
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
        layout = {
          position = "bottom", -- | top | left | right | bottom |
          ratio = 0.4
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = "<C-h>",
          accept_word = "<C-l>",
          accept_line = "<M-i>",
          next = "<C-k>",
          prev = "<C-j>",
          dismiss = "<C-j>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        telescopeprompt = false,
        ["."] = false,
      },
    })
  end,
  keys = {
    { "<leader>ct", function() require('copilot.suggestion').toggle_auto_trigger() end, desc = "Toggle Copilot" },
    { "<leader>cp", function() require('copilot.panel').toggle() end, desc = "Copilot Panel Toggle" },
  },

}
