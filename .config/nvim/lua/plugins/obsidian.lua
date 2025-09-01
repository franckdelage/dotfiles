return {
  'epwalsh/obsidian.nvim',
  version = '*',
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/Drive/SecondBrain/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/Drive/SecondBrain/*.md',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
