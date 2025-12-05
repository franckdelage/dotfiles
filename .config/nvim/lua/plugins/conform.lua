return {
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local ft = vim.bo[bufnr].filetype

          -- Step 1: Linter autofix
          -- ESLint autofix for JS/TS/HTML files
          local eslint_clients = vim.lsp.get_clients { bufnr = bufnr, name = "eslint" }
          if #eslint_clients > 0 then
            local client = eslint_clients[1]
            local success, result = pcall(
              function()
                return client:exec_cmd({
                  command = "eslint.executeAutofix",
                  arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
                }, { bufnr = bufnr })
              end
            )

            if not success or not result then
              -- Fallback to code action approach
              local range_params = vim.lsp.util.make_range_params(0, "utf-8")
              local params = {
                textDocument = range_params.textDocument,
                range = range_params.range,
                context = {
                  only = { "source.fixAll.eslint" },
                  diagnostics = vim.diagnostic.get(bufnr),
                },
              }

              vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, actions)
                if err or not actions then return end

                for _, action in ipairs(actions) do
                  if action.kind and action.kind:match "fixAll" then
                    if action.edit then
                      vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                    elseif action.command then
                      vim.lsp.buf_request(bufnr, "workspace/executeCommand", action.command, function() end)
                    end
                    break
                  end
                end
              end)
            end
            -- Small delay to let ESLint finish
            vim.defer_fn(function() vim.cmd "silent! write" end, 100)
          end

          -- Stylelint autofix for CSS/SCSS files via LSP formatting
          -- Note: We call LSP format first, then Conform will run prettierd after
          local stylelint_clients = vim.lsp.get_clients { bufnr = bufnr, name = "stylelint_lsp" }
          local has_stylelint = #stylelint_clients > 0 and (ft == "css" or ft == "scss" or ft == "sass")

          if has_stylelint then
            -- Use LSP formatting for stylelint (applies fixes)
            vim.lsp.buf.format {
              bufnr = bufnr,
              timeout_ms = 2000,
              filter = function(client) return client.name == "stylelint_lsp" end,
            }
          end

          -- Step 2: TypeScript fixes (add missing + remove unused imports)
          if ft == "typescript" or ft == "javascript" or ft == "typescriptreact" or ft == "javascriptreact" then
            vim.defer_fn(function()
              local actions_to_apply = { "source.addMissingImports.ts", "source.removeUnused.ts" }

              for _, action_kind in ipairs(actions_to_apply) do
                local range_params = vim.lsp.util.make_range_params(0, "utf-8")
                local params = {
                  textDocument = range_params.textDocument,
                  range = range_params.range,
                  context = {
                    only = { action_kind },
                    diagnostics = {},
                  },
                }

                vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, actions)
                  if err or not actions then return end

                  for _, action in ipairs(actions) do
                    if action.kind and action.kind:match(action_kind:gsub("source%.", "")) then
                      if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                      elseif action.command then
                        vim.lsp.buf_request(bufnr, "workspace/executeCommand", action.command, function() end)
                      end
                      break
                    end
                  end
                end)
              end

              -- Step 3: Conform formatting (after TS fixes)
              vim.defer_fn(function()
                require("conform").format({
                  async = true,
                  lsp_format = "fallback",
                  bufnr = bufnr,
                }, function(err)
                  if err then vim.notify("Formatting error: " .. vim.inspect(err), vim.log.levels.ERROR) end
                end)
              end, 200)
            end, 150)
          else
            -- Step 3: Just format if not TS/JS file
            -- Add extra delay if stylelint was called to let it finish
            local delay = has_stylelint and 250 or 150
            vim.defer_fn(function()
              require("conform").format({
                async = true,
                lsp_format = "fallback",
                bufnr = bufnr,
              }, function(err)
                if err then vim.notify("Formatting error: " .. vim.inspect(err), vim.log.levels.ERROR) end
              end)
            end, delay)
          end
        end,
        mode = "",
        desc = "Fix all (ESLint + TS + Format)",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      formatters_by_ft = {
        html = { "eslint", "prettierd" },
        htmlangular = { "eslint", "prettierd" },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        json = { "jq" },
        jsonc = { "jq" },
        lua = { "stylua" },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
