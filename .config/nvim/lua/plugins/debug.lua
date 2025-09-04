return {
  -- Mason for debug adapter management
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          'js-debug-adapter',
        },
      }
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    keys = {
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
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Disable automatic loading of .vscode/launch.json
      dap.ext = dap.ext or {}
      dap.ext.vscode = nil

      -- Setup DAP UI
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
        mappings = {
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.25 },
            },
            size = 80,
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 22,
            position = 'bottom',
          },
        },
        controls = {
          enabled = true,
          element = 'repl',
          icons = {
            disconnect = '',
            pause = '',
            play = '',
            run_last = '',
            step_back = '',
            step_into = '',
            step_out = '',
            step_over = '',
            terminate = '',
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = 'single',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
        },
      }

      -- Setup virtual text
      require('nvim-dap-virtual-text').setup {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        ---@diagnostic disable-next-line: unused-local
        display_callback = function(variable, _buf, _stackframe, _node, options)
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value
          else
            return variable.name .. ' = ' .. variable.value
          end
        end,
        virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      }

      -- Manual adapter setup since mason-nvim-dap isn't working
      local mason_path = vim.fn.stdpath 'data' .. '/mason'

      -- Node.js/JavaScript adapter
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            mason_path .. '/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }

      -- Chrome adapter
      dap.adapters['pwa-chrome'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            mason_path .. '/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }

      -- Debug configurations for your project
      for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
        dap.configurations[language] = {
          -- Debug Air France localhost
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = ' Debug AF (localhost.airfrance.fr)',
            url = 'https://localhost.airfrance.fr',
            webRoot = '${workspaceFolder}',
            skipFiles = {
              '<node_internals>/**',
              '${workspaceFolder}/node_modules/**',
            },
            sourceMaps = true,
          },
          -- Debug KLM localhost
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = ' Debug KLM (localhost.klm.nl)',
            url = 'https://localhost.klm.nl',
            webRoot = '${workspaceFolder}',
            skipFiles = {
              '<node_internals>/**',
              '${workspaceFolder}/node_modules/**',
            },
            sourceMaps = true,
          },
          -- Jest current file
          {
            type = 'pwa-node',
            request = 'launch',
            name = ' Debug Jest (Current File)',
            program = '${workspaceFolder}/node_modules/.bin/jest',
            args = {
              '--runInBand',
              '--testPathPattern=${relativeFile}',
              '--config=${workspaceFolder}/jest.config.ts',
            },
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
            skipFiles = {
              '<node_internals>/**',
              '${workspaceFolder}/node_modules/**',
            },
            sourceMaps = true,
          },
          -- Jest via Nx
          {
            type = 'pwa-node',
            request = 'launch',
            name = ' Debug Jest (Nx Project)',
            program = '${workspaceFolder}/node_modules/.bin/nx',
            args = function()
              local project = vim.fn.input 'Project name: '
              local testFile = vim.fn.input('Test file pattern (optional): ', '')
              local args = { 'test', project }
              if testFile ~= '' then
                table.insert(args, '--testPathPattern=' .. testFile)
              end
              table.insert(args, '--runInBand')
              return args
            end,
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
            skipFiles = {
              '<node_internals>/**',
              '${workspaceFolder}/node_modules/**',
            },
            sourceMaps = true,
          },
          -- Attach to GraphQL
          {
            type = 'pwa-node',
            request = 'attach',
            name = ' Attach GQL (9221)',
            port = 9221,
            restart = true,
            cwd = '${workspaceFolder}',
            sourceMaps = true,
            resolveSourceMapLocations = { '**', '!**/node_modules/**' },
            outFiles = { '${workspaceFolder}/dist/**/*.js' },
            skipFiles = {
              '<node_internals>/**',
              '${workspaceFolder}/node_modules/**',
            },
          },
          -- Debug GraphQL server
          -- {
          --   type = 'pwa-node',
          --   request = 'launch',
          --   name = ' Launch GraphQL Server',
          --   program = '${workspaceFolder}/node_modules/.bin/tsx',
          --   args = {
          --     '--tsconfig',
          --     '${workspaceFolder}/apps/gql/tsconfig.json',
          --     '${workspaceFolder}/apps/gql/src/main.ts',
          --   },
          --   cwd = '${workspaceFolder}',
          --   console = 'integratedTerminal',
          --   internalConsoleOptions = 'neverOpen',
          --   env = {
          --     NODE_ENV = 'development',
          --     PORT = '3000',
          --   },
          --   skipFiles = {
          --     '<node_internals>/**',
          --     '${workspaceFolder}/node_modules/**',
          --   },
          --   sourceMaps = true,
          -- },
        }
      end

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
