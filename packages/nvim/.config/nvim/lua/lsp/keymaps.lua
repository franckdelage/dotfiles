local utils = require "lsp.utils"
local M = {}

function M.setup()
  local attach_group = vim.api.nvim_create_augroup("PersonalLspAttach", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Configure buffer-local LSP behavior",
    group = attach_group,
    callback = function(event)
      if vim.bo[event.buf].buftype == "quickfix" then
        pcall(vim.lsp.buf_detach_client, event.buf, event.data.client_id)
        return
      end

      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      -- Hover documentation is handled globally by nvim-ufo's K mapping,
      -- which peeks folds first and falls back to vim.lsp.buf.hover().

      -- Keep TypeScript rename on plain vtsls. angularls still supplies Angular references,
      -- but its rename handling can reject decorated component classes.
      local rename = function()
        local filetype = vim.bo[event.buf].filetype
        local is_typescript = filetype == "typescript"
          or filetype == "typescriptreact"
          or filetype == "javascript"
          or filetype == "javascriptreact"
        local opts = is_typescript and { name = "vtsls" } or nil
        vim.lsp.buf.rename(nil, opts)
      end
      map("grn", rename, "Rename")
      map("<leader>ln", rename, "Rename")

      -- Execute a code action
      map("<leader>la", vim.lsp.buf.code_action, "Goto Code Action", { "n", "x" })

      -- Diagnostic navigation
      map(
        "[d",
        function() vim.diagnostic.jump { count = -1, float = false } end,
        "Go to Previous Diagnostic"
      )
      map(
        "]d",
        function() vim.diagnostic.jump { count = 1, float = false } end,
        "Go to Next Diagnostic"
      )

      -- Show line diagnostics in floating window
      map("<leader>le", vim.diagnostic.open_float, "Show Line Diagnostics")

      -- Add diagnostics to location list
      map("<leader>lq", vim.diagnostic.setloclist, "Add Diagnostics to Location List")

      -- Note: <leader>lf now handles unified fix (ESLint + TS + Format) via conform.lua
      -- Keeping granular TS import commands below for specific operations

      -- LSP: TypeScript add missing imports (ts_ls)
      map("<leader>lm", function()
        local ft = vim.bo[event.buf].filetype
        if
          ft ~= "typescript"
          and ft ~= "javascript"
          and ft ~= "typescriptreact"
          and ft ~= "javascriptreact"
        then
          vim.notify(
            "Add missing imports only available in TypeScript/JavaScript buffers",
            vim.log.levels.WARN
          )
          return
        end
        vim.lsp.buf.code_action {
          apply = true,
          context = {
            only = { "source.addMissingImports.ts" },
            diagnostics = {},
          },
        }
      end, "Add missing imports")

      -- LSP: TypeScript remove unused imports (ts_ls)
      map("<leader>lx", function()
        local ft = vim.bo[event.buf].filetype
        if
          ft ~= "typescript"
          and ft ~= "javascript"
          and ft ~= "typescriptreact"
          and ft ~= "javascriptreact"
        then
          vim.notify(
            "Remove unused imports only available in TypeScript/JavaScript buffers",
            vim.log.levels.WARN
          )
          return
        end
        vim.lsp.buf.code_action {
          apply = true,
          context = {
            only = { "source.removeUnused.ts" },
            diagnostics = {},
          },
        }
      end, "Remove unused imports")

      -- Workspace folders
      -- map('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
      -- map('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
      -- map('<leader>lwl', function()
      --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      -- end, 'List Workspace Folders')

      -- Configure document highlighting once per buffer, even when several clients attach.
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      local highlight_method = vim.lsp.protocol.Methods.textDocument_documentHighlight
      if
        client
        and client:supports_method(highlight_method, event.buf)
        and not vim.b[event.buf].personal_lsp_highlight_group
      then
        local group_name = "PersonalLspHighlight" .. event.buf
        local highlight_group = vim.api.nvim_create_augroup(group_name, { clear = true })
        vim.b[event.buf].personal_lsp_highlight_group = group_name

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          desc = "Highlight references under cursor",
          buffer = event.buf,
          group = highlight_group,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          desc = "Clear LSP reference highlights",
          buffer = event.buf,
          group = highlight_group,
          callback = vim.lsp.buf.clear_references,
        })
      end

      -- Inlay hints toggle
      if
        client
        and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
      then
        -- Enable inlay hints by default
        vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })

        map("<leader>lh", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          vim.notify(
            "Inlay hints "
              .. (vim.lsp.inlay_hint.is_enabled { bufnr = event.buf } and "enabled" or "disabled")
          )
        end, "[T]oggle Inlay [H]ints")
      end
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    desc = "Clean up document highlighting after final supporting client detaches",
    group = attach_group,
    callback = function(event)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(event.buf) then return end

        local highlight_method = vim.lsp.protocol.Methods.textDocument_documentHighlight
        for _, client in ipairs(vim.lsp.get_clients { bufnr = event.buf }) do
          if client:supports_method(highlight_method, event.buf) then return end
        end

        vim.lsp.buf.clear_references()
        local group_name = vim.b[event.buf].personal_lsp_highlight_group
        if group_name then
          pcall(vim.api.nvim_del_augroup_by_name, group_name)
          vim.b[event.buf].personal_lsp_highlight_group = nil
        end
      end)
    end,
  })
end

return M
