return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup {
      filter_kind = false,
      layout = {
        default_direction = 'prefer_left',
        min_width = 12,
      },
    }

    vim.keymap.set('n', '<leader>ta', '<cmd>AerialOpen<cr>', { desc = 'Aerial Open' })
    vim.keymap.set('n', '<leader>tn', '<cmd>AerialNavToggle<cr>', { desc = 'Aerial Open navigation' })
    vim.keymap.set('n', '<leader>tt', function () require('aerial').snacks_picker() end, { desc = 'Aerial list symbols' })
    vim.keymap.set('n', '<leader>tx', '<cmd>AerialCloseAll<cr>', { desc = 'Aerial Close all' })
  end,
}
