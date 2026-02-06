return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      vim.g.copilot_nes_debounce = 500
    end,
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-p>',
        },
        layout = {
          position = 'bottom', -- | top | left | right | bottom |
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = '<C-h>',
          accept_word = '<M-w>',
          accept_line = '<M-i>',
          next = '<C-k>',
          prev = '<C-j>',
          dismiss = '<C-e>',
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
      },
      copilot_model = 'claude-sonnet-4.5',
    }
  end,
  keys = {
    {
      '<leader>cc',
      '<cmd>Copilot enable<cr>',
      desc = 'Copilot Start',
    },
    {
      '<leader>cx',
      '<cmd>Copilot disable<cr>',
      desc = 'Copilot Stop',
    },
    {
      '<leader>cp',
      function()
        require('copilot.panel').toggle()
      end,
      desc = 'Copilot Panel Toggle',
    },
  },
}
