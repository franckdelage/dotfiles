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
  },
  lazy = false,
  config = function()
    require('refactoring').setup {
    }
  end,
  keys = {
    -- Extract operations (visual mode)
    {
      '<leader>re',
      function() return require('refactoring').extract_func() end,
      mode = { 'x', 'n' },
      expr = true,
      desc = 'Extract function',
    },
    {
      '<leader>rf',
      function() return require('refactoring').extract_func_to_file() end,
      mode = { 'x', 'n' },
      expr = true,
      desc = 'Extract function to file',
    },
    {
      '<leader>rv',
      function() return require('refactoring').extract_var() end,
      mode = 'x',
      expr = true,
      desc = 'Extract variable',
    },
    -- Inline operations (normal mode)
    {
      '<leader>ri',
      function() return require('refactoring').inline_func() end,
      mode = { 'n', 'x' },
      expr = true,
      desc = 'Inline function',
    },
    {
      '<leader>rI',
      function() return require('refactoring').inline_var() end,
      mode = { 'n', 'x' },
      expr = true,
      desc = 'Inline variable',
    },
    -- Debug statements
    {
      '<leader>rp',
      function() return require('refactoring.debug').print_var { output_location = "below" } .. "iw" end,
      mode = { 'n', 'x' },
      desc = 'Debug: print variable',
    },
    {
      '<leader>rP',
      function() return require('refactoring.debug').print_var { output_location = "above" } .. "iw" end,
      mode = 'n',
      desc = 'Debug: print function',
    },
    {
      '<leader>rc',
      function() return require('refactoring.debug').cleanup { restore_view = true } end,
      mode = 'n',
      desc = 'Debug: cleanup print statements',
    },
    -- Picker (all refactors via vim.ui.select)
    {
      '<leader>rr',
      function() return require('refactoring').select_refactor() end,
      mode = { 'n', 'x' },
      desc = 'Select refactor',
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
