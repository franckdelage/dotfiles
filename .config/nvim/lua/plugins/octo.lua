return {
  'pwntester/octo.nvim',
  -- commit = 'a6297cf215405c140c9e8f6a01b8e5d9aca794f2',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    enable_builtin = true,
    default_merge_method = 'squash',
    picker = 'sn',
    default_remote = { 'github', 'origin' },
    suppress_missing_scope = {
      projects_v2 = true,
    },
  },
  keys = {
    { '<leader>oo', '<cmd>Octo<cr>', desc = 'Octo' },
    { '<leader>ol', '<cmd>Octo pr list<cr>', desc = 'Octo PR List' },
    { '<leader>oc', '<cmd>Octo pr create<cr>', desc = 'Octo PR Create' },
    { '<leader>os', '<cmd>Octo pr search is:pr is:closed<cr>', desc = 'Octo PR search closed' },
  },
}
