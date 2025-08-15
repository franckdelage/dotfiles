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
      'folke/noice.nvim',
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
      local noice_ok, noice = pcall(require, 'noice')

      local function notify(msg, level)
        if noice_ok then
          noice.notify(msg, level or 'info', { title = 'Neotest' })
        else
          vim.notify(msg, vim.log.levels.INFO)
        end
      end

      local function find_nx_project(path)
        local current_dir = vim.fs.dirname(path)
        while current_dir and current_dir ~= '/' and current_dir ~= '' do
          local pj = current_dir .. '/project.json'
          if vim.fn.filereadable(pj) == 1 then
            local content = vim.fn.readfile(pj)
            local json_data = vim.fn.json_decode(content)
            if json_data and json_data.name then
              return json_data.name, current_dir
            end
          end
          local parent = vim.fs.dirname(current_dir)
          if parent == current_dir then
            break
          end
          current_dir = parent
        end
        return nil, nil
      end

      local function project_jest_config(project_dir)
        if not project_dir then
          return nil
        end
        -- Heuristic: prefer a local jest.config.ts in the project directory
        local candidate = project_dir .. '/jest.config.ts'
        if vim.fn.filereadable(candidate) == 1 then
          return candidate
        end
        -- Fallback to root aggregator
        if vim.fn.filereadable 'jest.config.ts' == 1 then
          return 'jest.config.ts'
        end
        return nil
      end

      require('neotest').setup {
        -- (Let discovery run; we removed the extra disable flags.)
        adapters = {
          require 'neotest-jest' {
            -- Removed jest_test_discovery=false to allow adapter fallback.
            jestCommand = function(path)
              -- Use a workspace-relative pattern for stability
              local rel = vim.fn.fnamemodify(path, ':.')
              local project, project_dir = find_nx_project(path)
              if project then
                local cmd = string.format('yarn nx %:tests --testPathPattern="%s"', project, rel)
                notify('Running: ' .. cmd)
                return cmd
              end
              local fallback = string.format('yarn jest --testPathPattern "%s"', rel)
              notify('Fallback: ' .. fallback, 'warn')
              return fallback
            end,
            jest_config_file = function(path)
              local _, project_dir = find_nx_project(path)
              local cfg = project_jest_config(project_dir)
              if cfg then
                notify('Using Jest config: ' .. cfg)
                return cfg
              end
              notify('No specific jest config found, defaulting', 'warn')
              return 'jest.config.ts'
            end,
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          },
        },
      }
    end,
  },
}
