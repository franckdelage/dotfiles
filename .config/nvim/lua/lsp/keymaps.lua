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

      -- Hover documentation is handled globally by nvim-ufo's K mapping,
      -- which peeks folds first and falls back to vim.lsp.buf.hover().

      -- Rename the variable under your cursor.
      map('<leader>ln', vim.lsp.buf.rename, 'Rename')

      -- Execute a code action
      map('<leader>la', vim.lsp.buf.code_action, 'Goto Code Action', { 'n', 'x' })

      -- Diagnostic navigation
      map('[d', function()
        vim.diagnostic.jump { count = -1, float = false }
      end, 'Go to Previous Diagnostic')
      map(']d', function()
        vim.diagnostic.jump { count = 1, float = false }
      end, 'Go to Next Diagnostic')

      -- Show line diagnostics in floating window
      map('<leader>le', vim.diagnostic.open_float, 'Show Line Diagnostics')

      -- Add diagnostics to location list
      map('<leader>lq', vim.diagnostic.setloclist, 'Add Diagnostics to Location List')

      -- Note: <leader>lf now handles unified fix (ESLint + TS + Format) via conform.lua
      -- Keeping granular TS import commands below for specific operations

      -- LSP: TypeScript add missing imports (ts_ls)
      map('<leader>lm', function()
        local ft = vim.bo[event.buf].filetype
        if ft ~= 'typescript' and ft ~= 'javascript' and ft ~= 'typescriptreact' and ft ~= 'javascriptreact' then
          vim.notify('Add missing imports only available in TypeScript/JavaScript buffers', vim.log.levels.WARN)
          return
        end
        vim.lsp.buf.code_action {
          apply = true,
          context = {
            only = { 'source.addMissingImports.ts' },
            diagnostics = {},
          },
        }
      end, 'Add missing imports')

      -- LSP: TypeScript remove unused imports (ts_ls)
      map('<leader>lx', function()
        local ft = vim.bo[event.buf].filetype
        if ft ~= 'typescript' and ft ~= 'javascript' and ft ~= 'typescriptreact' and ft ~= 'javascriptreact' then
          vim.notify('Remove unused imports only available in TypeScript/JavaScript buffers', vim.log.levels.WARN)
          return
        end
        vim.lsp.buf.code_action {
          apply = true,
          context = {
            only = { 'source.removeUnused.ts' },
            diagnostics = {},
          },
        }
      end, 'Remove unused imports')

      -- Workspace folders
      -- map('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
      -- map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
      -- map('<leader>lwl', function()
      --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      -- end, 'List Workspace Folders')

      -- Document highlight setup
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        -- Enable inlay hints by default
        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

        map('<leader>lh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          vim.notify('Inlay hints ' .. (vim.lsp.inlay_hint.is_enabled { bufnr = event.buf } and 'enabled' or 'disabled'))
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })
end

return M
