return {
  'yetone/avante.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  build = function()
    -- conditionally use the correct build system for the current OS
    if vim.fn.has 'win32' == 1 then
      return 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
    else
      return 'make'
    end
  end,
  event = 'VeryLazy',
  version = false,
  mode = 'agentic',
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    auto_suggestions_provider = 'copilot',
    provider = 'copilot',
    providers = {
      ollama = {
        endpoint = "http://localhost:11434",
        -- model = "deepseek-coder-v2",
        model = "qwen2.5-coder",
      },
      copilot = {
        endpoint = "https://api.github.com/copilot",
        model = "gpt-4o",
      },
    },
    windows = {
      input = {
        height = 12,
      },
      ask = {
        start_insert = false,
      }
    },
    input = {
      provider = 'snacks',
      provider_opts = {
        -- snacks.nvim options
        icon = " ",
      },
    },
  },
  keys = {
    { '<leader>ae', '<cmd>AvanteEdit<cr>', desc = 'Avante: Edit' },
  },
}
