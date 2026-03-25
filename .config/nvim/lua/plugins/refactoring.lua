local ts_js_print_var_statements = {
  "console.log('[[ DEBUG %s ]]', %s);",
  "#debug = effect(() => console.log('[[ DEBUG %s ]]', this. %s));",
  "#debugSignal = effect(() => console.log('[[ DEBUG %s ]]', this. %s()));",
  "/* %s */ #debugTable = effect(() => console.table(this. %s));",
  "/* %s */ #debugTableSignal = effect(() => console.table(this. %s()));",
}

return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = true,
  event = 'BufReadPre',
  config = function()
    require('refactoring').setup {
      print_var_statements = {
        typescript = ts_js_print_var_statements,
        javascript = ts_js_print_var_statements,
      },
    }
  end,
  keys = {
    -- Extract operations (visual mode)
    {
      '<leader>re',
      function() return require('refactoring').refactor 'Extract Function' end,
      mode = 'x',
      expr = true,
      desc = 'Extract function',
    },
    {
      '<leader>rf',
      function() return require('refactoring').refactor 'Extract Function To File' end,
      mode = 'x',
      expr = true,
      desc = 'Extract function to file',
    },
    {
      '<leader>rv',
      function() return require('refactoring').refactor 'Extract Variable' end,
      mode = 'x',
      expr = true,
      desc = 'Extract variable',
    },
    -- Inline operations (normal mode)
    {
      '<leader>ri',
      function() return require('refactoring').refactor 'Inline Function' end,
      mode = 'n',
      expr = true,
      desc = 'Inline function',
    },
    {
      '<leader>rI',
      function() return require('refactoring').refactor 'Inline Variable' end,
      mode = { 'n', 'x' },
      expr = true,
      desc = 'Inline variable',
    },
    -- Block operations (normal mode)
    {
      '<leader>rb',
      function() return require('refactoring').refactor 'Extract Block' end,
      mode = 'n',
      expr = true,
      desc = 'Extract block',
    },
    {
      '<leader>rB',
      function() return require('refactoring').refactor 'Extract Block To File' end,
      mode = 'n',
      expr = true,
      desc = 'Extract block to file',
    },
    -- Debug statements
    {
      '<leader>rp',
      function() require('refactoring').debug.print_var {} end,
      mode = { 'n', 'x' },
      desc = 'Debug: print variable',
    },
    {
      '<leader>rP',
      function() require('refactoring').debug.printf { below = false } end,
      mode = 'n',
      desc = 'Debug: print function',
    },
    {
      '<leader>rc',
      function() require('refactoring').debug.cleanup {} end,
      mode = 'n',
      desc = 'Debug: cleanup print statements',
    },
    -- Picker (all refactors via vim.ui.select)
    {
      '<leader>rr',
      function() require('refactoring').select_refactor() end,
      mode = { 'n', 'x' },
      desc = 'Select refactor',
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
