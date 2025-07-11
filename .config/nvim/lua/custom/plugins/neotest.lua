return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/nvim-nio',
      'antoinemadec/FixCursorHold.nvim',
      'folke/noice.nvim', -- For notifications
    },
    keys = {
      {
        '<leader>kn',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run nearest test',
      },
      {
        '<leader>kf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Run file tests',
      },
      {
        '<leader>kw',
        function()
          require('neotest').watch.toggle(vim.fn.expand '%')
        end,
        desc = 'Toggle watch file',
      },
      {
        '<leader>kl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run last test',
      },
      {
        '<leader>ko',
        function()
          require('neotest').output.open { enter = true }
        end,
        desc = 'Open output',
      },
      {
        '<leader>kp',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Toggle output panel',
      },
      {
        '<leader>ks',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Toggle summary',
      },
      {
        ']n',
        function()
          require('neotest').jump.next { status = 'failed' }
        end,
        desc = 'Next failed test',
      },
      {
        '[n',
        function()
          require('neotest').jump.prev { status = 'failed' }
        end,
        desc = 'Previous failed test',
      },
      {
        '<leader>kd',
        function()
          require('neotest').run.run { strategy = 'dap' }
        end,
        desc = 'Debug Last Test',
      },
    },
    config = function()
      local function find_nx_project(path)
        local current_dir = vim.fs.dirname(path)

        while current_dir ~= nil and current_dir ~= '/' and current_dir ~= '' do
          local project_json_path = current_dir .. '/project.json'

          if vim.fn.filereadable(project_json_path) == 1 then
            local content = vim.fn.readfile(project_json_path)
            local json_data = vim.fn.json_decode(content)
            if json_data and json_data.name then
              return json_data.name
            end
          end

          local parent_dir = vim.fs.dirname(current_dir)
          if parent_dir == current_dir then
            break
          end
          current_dir = parent_dir
        end

        return nil
      end

      require('neotest').setup {
        discovery = {
          enabled = false, -- Disable automatic discovery
        },
        adapters = {
          require 'neotest-jest' {
            jest_test_discovery = false, -- Disable automatic discovery of Jest tests
            jestCommand = function(path)
              local project = find_nx_project(path)
              if project then
                require("noice").notify(
                  "🚀 Test run in: " .. (project or "none"),
                  "info", -- Niveau de log (info, warn, error)
                  { title = "Neotest Debug" }
                )
                return string.format("yarn nx run %s:test --testPathPattern %s", project, path)
              end
              return "yarn jest --" .. path
            end,
            jest_config_file = "jest.config.ts",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          },
        },
      }
    end,
  },
}
