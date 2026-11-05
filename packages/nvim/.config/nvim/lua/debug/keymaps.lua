-- Debug keymaps for DAP
return {
  {
    '<leader>dd',
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
    '<leader>dc',
    function()
      require('dap').clear_breakpoints()
    end,
    desc = 'Clear Breakpoints',
  },
  {
    '<leader>dt',
    function()
      require('dap-view').toggle()
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
    '<leader>dw',
    function()
      require('dap-view').add_expr()
    end,
    desc = 'Watch Expression',
    mode = { 'n', 'v' },
  },
  {
    '<leader>ds',
    function()
      require("dap-view").jump_to_view("scopes")
    end,
    desc = 'Scopes',
  },
}
