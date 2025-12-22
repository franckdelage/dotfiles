return {
  'yetone/avante.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  build = 'make',
  event = 'VeryLazy',
  version = false,
  ---@module 'avante'
  opts = {
    auto_suggestions_provider = 'copilot',
    provider = 'copilot',
    providers = {
      copilot = {
        endpoint = 'https://api.github.com/copilot',
        model = 'claude-sonnet-4.5',
      },
    },
    windows = {
      input = {
        height = 12,
      },
      ask = {
        start_insert = false,
      },
    },
    input = {
      provider = 'snacks',
      provider_opts = {
        -- snacks.nvim options
        icon = ' ',
      },
    },
  },
  keys = {
    { '<leader>ae', '<cmd>AvanteEdit<cr>', desc = 'avante: Edit' },
    { '<leader>al', '<cmd>AvanteClear<cr>', desc = 'avante: Clear' },
  },
}
