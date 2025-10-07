return {
  'echasnovski/mini.ai',
  version = false, -- use the latest commit
  event = 'VeryLazy',
  config = function()
    require('mini.ai').setup {
      n_lines = 500,
    }
  end,
}
