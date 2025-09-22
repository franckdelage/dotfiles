local utils = require('lsp.utils')
local servers = require('lsp.servers.init')
local keymaps = require('lsp.keymaps')
local diagnostics = require('lsp.diagnostics')

local M = {}

function M.setup()
  -- Setup diagnostics
  diagnostics.setup()

  -- Setup keymaps and LspAttach autocmd
  keymaps.setup()

  -- Create autocmds for each server based on filetype
  for _, server_config in pairs(servers.servers) do
    vim.api.nvim_create_autocmd('FileType', {
      pattern = server_config.filetypes,
      callback = function(event)
        -- Check if this server is already running for this buffer
        local clients = vim.lsp.get_clients({ bufnr = event.buf, name = server_config.name })
        if #clients == 0 then
          utils.start_lsp_server(server_config, event.buf)
        end
      end,
    })
  end

  -- Special handling for eslint - enable it explicitly
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { '*.ts', '*.js', '*.tsx', '*.jsx', '*.html' },
    callback = function(event)
      local clients = vim.lsp.get_clients({ bufnr = event.buf, name = 'eslint' })
      if #clients == 0 then
        utils.start_lsp_server(servers.servers.eslint, event.buf)
      end
    end,
  })
end

return M
