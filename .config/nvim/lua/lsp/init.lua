local utils = require 'lsp.utils'
local servers = require 'lsp.servers.init'
local keymaps = require 'lsp.keymaps'
local diagnostics = require 'lsp.diagnostics'

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
        local clients = vim.lsp.get_clients { bufnr = event.buf, name = server_config.name }
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
      local clients = vim.lsp.get_clients { bufnr = event.buf, name = 'eslint' }
      if #clients == 0 then
        utils.start_lsp_server(servers.servers.eslint, event.buf)
      end
    end,
  })

  -- Create user commands
  vim.api.nvim_create_user_command('LspInfo', function()
    local buf_clients = vim.lsp.get_clients { bufnr = 0 }
    local all_clients = vim.lsp.get_clients()

    local lines = { 'LSP client info for current buffer:', '' }

    if #buf_clients == 0 then
      table.insert(lines, 'No LSP clients attached to this buffer')
    else
      for _, client in ipairs(buf_clients) do
        table.insert(lines, string.format('Client: %s (id %d)', client.name, client.id))
        table.insert(lines, string.format('  Root dir: %s', client.root_dir or 'N/A'))
        table.insert(lines, '')
      end
    end

    table.insert(lines, 'All active LSP clients:')
    table.insert(lines, '')
    if #all_clients == 0 then
      table.insert(lines, 'No active LSP clients')
    else
      for _, client in ipairs(all_clients) do
        table.insert(lines, string.format('  %s (id %d)', client.name, client.id))
      end
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = 'lspinfo'

    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      row = math.floor(vim.o.lines * 0.1),
      col = math.floor(vim.o.columns * 0.1),
      style = 'minimal',
      border = 'rounded',
    })

    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
  end, { desc = 'Show LSP client information' })
end

return M
