-- Debug keymaps for DAP
return {
  {
    '<leader>dc',
    function()
      require('dap').continue()
    end,
    desc = 'Start/Continue',
  },
  {
    '<leader>di',
    function()
      require('dap').step_into()
    end,
    desc = 'Step Into',
  },
  {
    '<leader>do',
    function()
      require('dap').step_over()
    end,
    desc = 'Step Over',
  },
  {
    '<leader>du',
    function()
      require('dap').step_out()
    end,
    desc = 'Step Out',
  },
  {
    '<leader>db',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = 'Toggle Breakpoint',
  },
  {
    '<leader>dB',
    function()
      require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end,
    desc = 'Set Conditional Breakpoint',
  },
  {
    '<leader>dt',
    function()
      require('dapui').toggle()
    end,
    desc = 'Toggle UI',
  },
  {
    '<leader>dr',
    function()
      require('dap').repl.open()
    end,
    desc = 'Open REPL',
  },
  {
    '<leader>dl',
    function()
      require('dap').run_last()
    end,
    desc = 'Run Last',
  },
  {
    '<leader>dx',
    function()
      require('dap').terminate()
    end,
    desc = 'Stop',
  },
  {
    '<leader>de',
    function()
      require('dapui').eval()
    end,
    desc = 'Evaluate',
    mode = { 'n', 'v' },
  },
  {
    '<leader>dh',
    function()
      require('dap.ui.widgets').hover()
    end,
    desc = 'Hover',
    mode = { 'n', 'v' },
  },
  {
    '<leader>dp',
    function()
      require('dap.ui.widgets').preview()
    end,
    desc = 'Preview',
    mode = { 'n', 'v' },
  },
  {
    '<leader>df',
    function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.frames)
    end,
    desc = 'Frames',
  },
  {
    '<leader>ds',
    function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.scopes)
    end,
    desc = 'Scopes',
  },
}