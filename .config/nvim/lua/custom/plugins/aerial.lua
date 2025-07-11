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

    vim.keymap.set('n', '<leader>ta', '<cmd>AerialOpen<cr>', { desc = 'Open' })
    vim.keymap.set('n', '<leader>tn', '<cmd>AerialNavToggle<cr>', { desc = 'Open navigation' })
    vim.keymap.set('n', '<leader>tc', '<cmd>AerialCloseAll<cr>', { desc = 'Close all' })
  end,
}
