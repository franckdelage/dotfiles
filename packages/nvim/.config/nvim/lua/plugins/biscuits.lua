return {
  'code-biscuits/nvim-biscuits',
  event = 'VeryLazy',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('nvim-biscuits').setup {
      toggle_keybind = '<leader>tb',
      show_on_start = false,
      cursor_line_only = true,
      default_config = {
        max_length = 12,
        min_distance = 5,
        prefix_string = ' 📎 ',
      },
      language_config = {
        html = {
          prefix_string = ' 🌐 ',
        },
        javascript = {
          prefix_string = ' ✨ ',
          max_length = 80,
        },
        typescript = {
          prefix_string = ' ✨ ',
          max_length = 80,
        },
        python = {
          disabled = true,
        },
      },
    }
  end,
}
