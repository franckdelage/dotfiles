-- Debug adapters configuration
local M = {}

function M.setup_adapters(dap)
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
end

return M
