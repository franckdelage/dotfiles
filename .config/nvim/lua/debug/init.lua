local M = {}

function M.setup()
  local dap = require 'dap'
  local dapview = require 'dap-view'

  -- Setup debug adapters
  require('debug.adapters').setup_adapters(dap)

  -- Setup debug configurations
  require('debug.configurations').setup_configurations(dap)

  -- Setup UI and virtual text
  require('debug.ui').setup_ui(dap, dapview)

  -- Enable verbose DAP logging (~/.cache/nvim/dap.log)
  -- dap.set_log_level 'TRACE'

  -- Disable automatic loading of .vscode/launch.json
  dap.ext = dap.ext or {}
  dap.ext.vscode = nil

  -- Setup icons after everything else (timing issue fix)
  vim.schedule(function()
    require('debug.ui').setup_icons()
  end)
end

return M
