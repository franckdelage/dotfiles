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

      -- Restart LSP server
      map('<leader>lR', '<cmd>LspRestart<CR>', 'Restart LSP Server', { 'n' })

      -- Execute a code action
      map('<leader>la', vim.lsp.buf.code_action, 'Goto Code Action', { 'n', 'x' })

      -- Fuzzy find all the symbols in your current workspace.
      map('grW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

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

      -- Note: <leader>lf now handles unified fix (ESLint + TS + Format) via conform.lua
      -- Keeping granular TS import commands below for specific operations

      -- LSP: TypeScript add missing imports (ts_ls)
      map('<leader>lm', function()
        local ft = vim.bo[event.buf].filetype
        if ft ~= 'typescript' and ft ~= 'javascript' and ft ~= 'typescriptreact' and ft ~= 'javascriptreact' then
          vim.notify('Add missing imports only available in TypeScript/JavaScript buffers', vim.log.levels.WARN)
          return
        end

        local range_params = vim.lsp.util.make_range_params(0, "utf-8")
        local params = {
          textDocument = range_params.textDocument,
          range = range_params.range,
          context = {
            only = { 'source.addMissingImports.ts' },
            diagnostics = {},
          },
        }

        vim.lsp.buf_request(event.buf, 'textDocument/codeAction', params, function(err, actions)
          if err then
            vim.notify('Error requesting code actions: ' .. vim.inspect(err), vim.log.levels.ERROR)
            return
          end

          if not actions then
            return
          end

          -- Apply the first matching action
          for _, action in ipairs(actions) do
            if action.kind and action.kind:match 'addMissingImports' then
              if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
              elseif action.command then
                local command = action.command
                vim.lsp.buf_request(event.buf, 'workspace/executeCommand', command, function() end)
              end
              return
            end
          end
        end)
      end, 'Add missing imports')

      -- LSP: TypeScript remove unused imports (ts_ls)
      map('<leader>lx', function()
        local ft = vim.bo[event.buf].filetype
        if ft ~= 'typescript' and ft ~= 'javascript' and ft ~= 'typescriptreact' and ft ~= 'javascriptreact' then
          vim.notify('Remove unused imports only available in TypeScript/JavaScript buffers', vim.log.levels.WARN)
          return
        end

        local range_params = vim.lsp.util.make_range_params(0, "utf-8")
        local params = {
          textDocument = range_params.textDocument,
          range = range_params.range,
          context = {
            only = { 'source.removeUnused.ts' },
            diagnostics = {},
          },
        }

        vim.lsp.buf_request(event.buf, 'textDocument/codeAction', params, function(err, actions)
          if err then
            vim.notify('Error requesting code actions: ' .. vim.inspect(err), vim.log.levels.ERROR)
            return
          end

          if not actions then
            return
          end

          -- Apply the first matching action
          for _, action in ipairs(actions) do
            if action.kind and action.kind:match 'removeUnused' then
              if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
              elseif action.command then
                local command = action.command
                vim.lsp.buf_request(event.buf, 'workspace/executeCommand', command, function() end)
              end
              return
            end
          end
        end)
      end, 'Remove unused imports')

      -- Workspace folders
      -- map('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
      -- map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
      -- map('<leader>lwl', function()
      --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      -- end, 'List Workspace Folders')

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
