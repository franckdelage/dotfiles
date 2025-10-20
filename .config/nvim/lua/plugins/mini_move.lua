return {
  'nvim-mini/mini.move',
  config = function()
    require('mini.move').setup {
      mappings = {
        left = '<M-H>',
        right = '<M-L>',
        down = '<M-J>',
        up = '<M-K>',
        line_left = '<M-H>',
        line_right = '<M-L>',
        line_down = '<M-J>',
        line_up = '<M-K>',
      },
      options = {
        reindent_linewise = true,
      },
    }
  end,
}
