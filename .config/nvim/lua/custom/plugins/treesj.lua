return {
  'Wansmer/treesj',
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup {
      use_default_keymaps = false,
    }

    vim.keymap.set('n', '<leader>js', '<cmd>TSJSplit<cr>', { desc = 'Split' })
    vim.keymap.set('n', '<leader>jj', '<cmd>TSJJoin<cr>', { desc = 'Join' })
    vim.keymap.set('n', '<leader>jt', '<cmd>TSJToggle<cr>', { desc = 'Toggle' })
  end,
}
