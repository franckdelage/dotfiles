return {
  'Wansmer/treesj',
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local lang_utils = require 'treesj.langs.utils'
    require('treesj').setup {
      use_default_keymaps = false,
      langs = {
        angular = {
          start_tag = lang_utils.set_default_preset {
            both = {
              omit = { 'tag_name' },
            },
          },
          self_closing_tag = lang_utils.set_default_preset {
            both = {
              omit = { 'tag_name' },
              no_format_with = {},
            },
          },
          element = lang_utils.set_default_preset {
            join = {
              space_separator = false,
            },
          },
        },
      },
    }

    vim.keymap.set('n', '<leader>js', '<cmd>TSJSplit<cr>', { desc = 'Split' })
    vim.keymap.set('n', '<leader>jj', '<cmd>TSJJoin<cr>', { desc = 'Join' })
    vim.keymap.set('n', '<leader>jt', '<cmd>TSJToggle<cr>', { desc = 'Toggle' })
  end,
}
