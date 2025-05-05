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
        shuttle = ']w',
      },
    },
  },
  keys = {
    { 'gd', '<cmd>Lspsaga peek_definition<cr>', desc = 'Peek Definition' },
    { 'gD', '<cmd>Lspsaga goto_definition<cr>', desc = 'Go to Definition' },
    { 'gy', '<cmd>Lspsaga goto_type_definition<cr>', desc = 'Go to type Definition' },
    { 'K', '<cmd>Lspsaga hover_doc<cr>', desc = 'Hover Documentation' },
    { 'gl', '<cmd>Lspsaga diagnostic_jump_next<cr>', desc = 'Next Diagnostic' },
    { 'gL', '<cmd>Lspsaga diagnostic_jump_prev<cr>', desc = 'Previous Diagnostic' },
    { 'gb', '<cmd>Lspsaga show_buf_diagnostics<cr>', desc = 'Buffer Diagnostics' },
    { 'gh', '<cmd>Lspsaga show_cursor_diagnostics<cr>', desc = 'Cursor Diagnostics' },
  },
}
