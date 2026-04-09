-- Debug configurations for different languages
local M = {}

function M.setup_configurations(dap)
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
      -- Vitest current file
      {
        type = 'pwa-node',
        request = 'launch',
        name = ' Debug Vitest (Current File)',
        -- yarn is a shell script; pwa-node needs the actual .js entry point.
        -- Resolve yarn dynamically via `which` then parse its exec line.
        program = function()
          local yarn_bin = vim.fn.trim(vim.fn.system 'which yarn')
          if yarn_bin == '' then return 'yarn' end

          local f = io.open(yarn_bin, 'r')
          if f then
            for line in f:lines() do
              local js = line:match('exec%s+"([^"]+yarn%.js)"')
              if js then f:close(); return js end
            end
            f:close()
          end

          return yarn_bin  -- fallback: already a JS file or unknown layout
        end,
        args = function()
          local file_path = vim.fn.expand '%:p'
          local file_dir = vim.fn.fnamemodify(file_path, ':h')
          local file_name = vim.fn.fnamemodify(file_path, ':t:r')  -- strip extension (e.g. refund-options.component.spec)

          -- Walk up to find nearest project.json and read the Nx project name
          local project_name = nil
          local current = file_dir
          while current ~= '/' and current ~= '' do
            local pj = current .. '/project.json'
            if vim.fn.filereadable(pj) == 1 then
              local ok, data = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(pj), '\n'))
              if ok and data and data.name then
                project_name = data.name
              end
              break
            end
            current = vim.fn.fnamemodify(current, ':h')
          end

          if not project_name then
            project_name = vim.fn.input 'Project name: '
          end

          return {
            'nx', 'run', project_name .. ':test',
            '--debug',
            '--watch=false',
            '--include=' .. file_path,
          }
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
      -- Jest current file
      {
        type = 'pwa-node',
        request = 'launch',
        name = ' Debug Jest (Current File)',
        program = '${workspaceFolder}/node_modules/.bin/jest',
        args = {
          '--runInBand',
          '--testPathPatterns=${relativeFile}',
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
    }
  end
end

return M
