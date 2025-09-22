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
    }
  end
end

return M
