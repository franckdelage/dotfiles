return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'lewis6991/async.nvim',
  },
  lazy = false,
  config = function()
    local function js_print_loc(opts)
      return ([[console.log("%s %s")]]):format(opts.debug_path, opts.count)
    end
    local function js_print_exp(opts)
      return ([[console.log("%s %s %s:", %s)]]):format(
        opts.debug_path:gsub('"', '\\"'),
        opts.expression_str:gsub('"', '\\"'),
        opts.count,
        opts.expression
      )
    end
    require('refactoring').setup {
      debug = {
        print_loc = {
          code_generation = {
            print_loc = {
              typescript = js_print_loc,
              typescriptreact = js_print_loc,
            },
          },
        },
        print_exp = {
          code_generation = {
            print_exp = {
              typescript = js_print_exp,
              typescriptreact = js_print_exp,
            },
          },
        },
      },
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
    -- Debug: print variable
    {
      '<leader>rp',
      function() return require('refactoring.debug').print_var { output_location = "below" } .. "iw" end,
      mode = 'n',
      expr = true,
      desc = 'Debug: print variable below (word)',
    },
    {
      '<leader>rp',
      function() return require('refactoring.debug').print_var { output_location = "below" } end,
      mode = 'x',
      expr = true,
      desc = 'Debug: print variable below (selection)',
    },
    {
      '<leader>rP',
      function() return require('refactoring.debug').print_var { output_location = "above" } .. "iw" end,
      mode = 'n',
      expr = true,
      desc = 'Debug: print variable above (word)',
    },
    {
      '<leader>rP',
      function() return require('refactoring.debug').print_var { output_location = "above" } end,
      mode = 'x',
      expr = true,
      desc = 'Debug: print variable above (selection)',
    },
    -- Debug: print expression
    {
      '<leader>rxx',
      function() return require('refactoring.debug').print_exp { output_location = "below" } end,
      mode = { 'n', 'x' },
      expr = true,
      desc = 'Debug: print expression below',
    },
    {
      '<leader>rxX',
      function() return require('refactoring.debug').print_exp { output_location = "below" } .. "_" end,
      mode = 'n',
      expr = true,
      desc = 'Debug: print expression below (line)',
    },
    {
      '<leader>rxa',
      function() return require('refactoring.debug').print_exp { output_location = "above" } end,
      mode = { 'n', 'x' },
      expr = true,
      desc = 'Debug: print expression above',
    },
    {
      '<leader>rxA',
      function() return require('refactoring.debug').print_exp { output_location = "above" } .. "_" end,
      mode = 'n',
      expr = true,
      desc = 'Debug: print expression above (line)',
    },
    -- Debug: print location
    {
      '<leader>rl',
      function() return require('refactoring.debug').print_loc { output_location = "below" } end,
      mode = 'n',
      expr = true,
      desc = 'Debug: print location below',
    },
    {
      '<leader>rL',
      function() return require('refactoring.debug').print_loc { output_location = "above" } end,
      mode = 'n',
      expr = true,
      desc = 'Debug: print location above',
    },
    -- Debug: cleanup
    {
      '<leader>rc',
      function() return require('refactoring.debug').cleanup { restore_view = true } .. "ag" end,
      mode = { 'n', 'x' },
      expr = true,
      remap = true,
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
