return {
  {
    'nvim-neotest/neotest',
    -- commit = '52fca6717ef972113ddd6ca223e30ad0abb2800c',
    lazy = true,
    dependencies = {
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/nvim-nio',
      'antoinemadec/FixCursorHold.nvim',
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
      -- Patch: add_to_rtp is called in client/init.lua but is missing from
      -- subprocess.lua on origin/master (bf9d3a4). It exists on a divergent
      -- branch that hasn't been merged yet. Remove this once upstream resolves it.
      local sub = require 'neotest.lib.subprocess'
      if not sub.add_to_rtp then
        local Path = require 'plenary.path'
        local function is_root(p)
          return p == '/' or p:match '^[A-Z]:\\?$'
        end
        sub.add_to_rtp = function(to_add)
          local rtp = sub.request('nvim_get_option_value', 'runtimepath', {})
          for _, func in ipairs(to_add) do
            local source = Path:new(debug.getinfo(func).source:sub(2))
            while not is_root(source.filename) and not vim.endswith(source.filename, Path.path.sep .. 'lua') do
              source = source:parent()
            end
            if not is_root(source.filename) then
              rtp = rtp .. ',' .. source:parent().filename
            end
          end
          sub.request('nvim_set_option_value', 'runtimepath', rtp, {})
        end
      end

      local function notify(msg)
        vim.notify(msg, vim.log.levels.INFO)
      end

      local function find_nx_project(path)
        local current_dir = vim.fs.dirname(path)

        while current_dir ~= nil and current_dir ~= '/' and current_dir ~= '' do
          local project_json_path = current_dir .. '/project.json'

          local f = io.open(project_json_path, 'r')
          if f then
            local raw = f:read '*a'
            f:close()
            local ok, json_data = pcall(vim.json.decode, raw)
            if ok and json_data and json_data.name then
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

      -- Returns the lib root directory (the one containing vitest-base.config.ts)
      -- if the file belongs to a vitest-migrated lib, otherwise returns nil.
      local function find_vitest_lib_root(path)
        local current_dir = vim.fs.dirname(path)

        while current_dir ~= nil and current_dir ~= '/' and current_dir ~= '' do
          local f = io.open(current_dir .. '/vitest-base.config.ts', 'r')
          if f then
            f:close()
            return current_dir
          end

          local parent_dir = vim.fs.dirname(current_dir)
          if parent_dir == current_dir then
            break
          end
          current_dir = parent_dir
        end

        return nil
      end

      -- Resolve wrapper script path relative to this lua file:
      -- this file is at <nvim-config>/lua/plugins/neotest.lua
      -- wrapper is at   <nvim-config>/scripts/nx-vitest-wrapper.sh
      local this_file = debug.getinfo(1, 'S').source:sub(2) -- strip leading '@'
      local nvim_config_root = vim.fn.fnamemodify(this_file, ':h:h:h')
      local wrapper_script = nvim_config_root .. '/scripts/nx-vitest-wrapper.sh'

      require('neotest').setup {
        discovery = {
          enabled = false, -- Disable automatic discovery
        },
        adapters = {
          require 'neotest-jest' {
            jest_test_discovery = false, -- Disable automatic discovery
            jestCommand = function(path)
              local project = find_nx_project(path)
              if project then
                notify('🚀 Running tests in project: ' .. project)
                return string.format('yarn nx run %s:test %s', project, path)
              end
              return 'yarn jest --' .. path
            end,
            jestConfigFile = 'jest.config.ts',
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
            isTestFile = function(path)
              -- Exclude files that belong to vitest-migrated libs
              if find_vitest_lib_root(path) then
                return false
              end
              return path:match '%.spec%.[jt]sx?$' ~= nil or path:match '%.test%.[jt]sx?$' ~= nil
            end,
          },
          require 'neotest-vitest' {
            -- Only claim files in libs that have a vitest-base.config.ts
            is_test_file = function(path)
              return find_vitest_lib_root(path) ~= nil
            end,
            -- Suppress vitest config discovery: vitest-base.config.ts is intentionally
            -- incomplete and must be run through the nx executor.
            vitestConfigFile = function()
              return nil
            end,
            vitestCommand = function(path)
              local project = find_nx_project(path)
              if project then
                notify('🚀 Running tests in project: ' .. project)
                return wrapper_script .. ' ' .. project
              end
              -- Fallback: should not happen for a vitest lib, but be safe
              return wrapper_script .. ' unknown'
            end,
            cwd = function()
              return vim.fn.getcwd()
            end,
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.7,
          border = 'rounded',
        },
        summary = {
          open = "botright vsplit | vertical resize 70",
        },
      }
    end,
  },
}
