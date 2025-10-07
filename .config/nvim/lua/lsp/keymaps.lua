local utils = require 'lsp.utils'
local M = {}

function M.setup()
  -- LSP Attach autocmd for keymaps and functionality
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      map('<leader>ln', vim.lsp.buf.rename, 'Rename')

      -- Execute a code action
      map('<leader>la', vim.lsp.buf.code_action, 'Goto Code Action', { 'n', 'x' })

      -- Find references for the word under your cursor.
      map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

      -- Jump to the implementation of the word under your cursor.
      map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

      -- Jump to the definition of the word under your cursor.
      map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

      -- Goto Declaration
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Fuzzy find all the symbols in your current document.
      map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

      -- Fuzzy find all the symbols in your current workspace.
      map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

      -- Jump to the type of the word under your cursor.
      map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

      -- Show signature help
      -- map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', { 'n', 'i' })

      -- Format document or selection
      -- map('<leader>lf', function()
      --   vim.lsp.buf.format({ async = true })
      -- end, 'Format Document')
      -- map('<leader>lf', function()
      --   vim.lsp.buf.format({ async = true })
      -- end, 'Format Selection', 'v')

      -- Diagnostic navigation
      map('[d', function()
        vim.diagnostic.jump { count = -1, float = true }
      end, 'Go to Previous Diagnostic')
      map(']d', function()
        vim.diagnostic.jump { count = 1, float = true }
      end, 'Go to Next Diagnostic')

      -- Show line diagnostics in floating window
      map('<leader>le', vim.diagnostic.open_float, 'Show Line Diagnostics')

      -- Add diagnostics to location list
      map('<leader>lq', vim.diagnostic.setloclist, 'Add Diagnostics to Location List')

      -- ESLint autofix
      map('<leader>lc', function()
        local clients = vim.lsp.get_clients { bufnr = event.buf, name = 'eslint' }
        if #clients > 0 then
          local client = clients[1]
          -- Use ESLint's executeAutofix command with the new API
          local success, result = pcall(function()
            return client:exec_cmd({
              command = 'eslint.executeAutofix',
              arguments = { { uri = vim.uri_from_bufnr(event.buf) } },
            }, { bufnr = event.buf })
          end)

          if success and result then
            vim.notify('ESLint autofix applied', vim.log.levels.INFO)
          else
            -- Fallback to code action approach
            vim.lsp.buf.code_action {
              context = {
                only = { 'source.fixAll' },
                diagnostics = vim.diagnostic.get(event.buf),
              },
              apply = true,
            }
            vim.notify('ESLint fixes applied via code action', vim.log.levels.INFO)
          end
        else
          vim.notify('ESLint LSP not attached to this buffer', vim.log.levels.WARN)
        end
      end, 'ESLint Autofix')

      -- Workspace folders
      map('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
      map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
      map('<leader>lwl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, 'List Workspace Folders')

      -- Document highlight setup
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and utils.client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- Inlay hints toggle
      if client and utils.client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map('<leader>lh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })
end

return M
