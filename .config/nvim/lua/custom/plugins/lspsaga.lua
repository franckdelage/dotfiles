return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
  opts = {
    definition = {
      width = 0.9,
      height = 0.8,
    },
    symbol_in_winbar = {
      enable = false,
      show_file = false,
    },
    lightbulb = {
      enable = false,
    },
    finder = {
      max_height = 0.7,
      default = 'ref+imp+def',
      keys = {
        vsplit = 'v',
        split = 'h',
        shuttle = ']w'
      }
    }
  },
  keys = {
    { "gd", '<cmd>Lspsaga peek_definition<cr>', desc = "Goto Definition" },
  }
}
