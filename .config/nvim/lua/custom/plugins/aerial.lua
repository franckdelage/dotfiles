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

    vim.keymap.set('n', '<leader>aa', '<cmd>AerialOpen<cr>', { desc = 'Aerial Open' })
    vim.keymap.set('n', '<leader>an', '<cmd>AerialNavToggle<cr>', { desc = 'Aerial Open' })
    vim.keymap.set('n', '<leader>ac', '<cmd>AerialCloseAll<cr>', { desc = 'Aerial Open' })
  end,
}
