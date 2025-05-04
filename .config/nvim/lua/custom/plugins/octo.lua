return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    enable_builtin = true,
    default_remote = { 'github', 'origin' },
    suppress_missing_scope = {
      projects_v2 = true,
    },
  },
  keys = {
    { '<leader>oo', '<cmd>Octo<cr>', desc = 'Octo' },
    { '<leader>ol', '<cmd>Octo pr list<cr>', desc = 'Octo PR List' },
    { '<leader>oc', '<cmd>Octo pr create<cr>', desc = 'Octo PR Create' },
  },
}
