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

      -- LSP: TypeScript add missing imports (ts_ls)
      map('<leader>lm', function()
        local ft = vim.bo[event.buf].filetype
        if ft ~= 'typescript' and ft ~= 'javascript' then
          vim.notify('Add missing imports only available in TypeScript/JavaScript buffers', vim.log.levels.WARN)
          return
        end
        -- Request the specific code action from tsserver/typescript-language-server
        -- Build an explicit context including current diagnostics to satisfy LuaLS typing
        local ctx = {
          only = { 'source.addMissingImports.ts' },
          diagnostics = vim.diagnostic.get(event.buf),
        }
        -- The action kind 'source.addMissingImports.ts' is provided by typescript-language-server even if not in the default spec
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.lsp.buf.code_action {
          context = ctx,
          apply = true,
        }
      end, 'Add missing imports')

      -- LSP: TypeScript remove unused imports (ts_ls)
      map('<leader>lx', function()
        local ft = vim.bo[event.buf].filetype
        if ft ~= 'typescript' and ft ~= 'javascript' then
          vim.notify('Remove unused imports only available in TypeScript/JavaScript buffers', vim.log.levels.WARN)
          return
        end
        -- Request the specific code action from tsserver/typescript-language-server
        local ctx = {
          only = { 'source.removeUnused.ts' },
          diagnostics = vim.diagnostic.get(event.buf),
        }
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.lsp.buf.code_action {
          context = ctx,
          apply = true,
        }
      end, 'Remove unused imports')

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
