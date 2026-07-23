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
          local is_ts = ft == "typescript" or ft == "javascript" or ft == "typescriptreact" or ft == "javascriptreact"
          local is_style = ft == "css" or ft == "scss" or ft == "sass"

          local function apply_action(action, done)
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
            end
            if action.command then
              vim.lsp.buf_request(bufnr, "workspace/executeCommand", action.command, function()
                done()
              end)
              return
            end
            done()
          end

          local function action_matches(action, kind)
            return action.kind == kind or (action.kind and action.kind:match(kind:gsub("source%.", "")))
          end

          local function apply_code_action(kind, diagnostics, done)
            local range_params = vim.lsp.util.make_range_params(0, "utf-8")
            local params = {
              textDocument = range_params.textDocument,
              range = range_params.range,
              context = {
                only = { kind },
                diagnostics = diagnostics or {},
              },
            }

            vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, actions)
              if err or not actions then
                done()
                return
              end

              for _, action in ipairs(actions) do
                if action_matches(action, kind) then
                  apply_action(action, done)
                  return
                end
              end
              done()
            end)
          end

          local function apply_code_action_sync(kind, diagnostics)
            local range_params = vim.lsp.util.make_range_params(0, "utf-8")
            local params = {
              textDocument = range_params.textDocument,
              range = range_params.range,
              context = {
                only = { kind },
                diagnostics = diagnostics or {},
              },
            }

            local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 2000)
            if not results then return false end

            local applied = false
            for _, response in pairs(results) do
              for _, action in ipairs(response.result or {}) do
                if action_matches(action, kind) then
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                    applied = true
                  end
                  if action.command then
                    vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", action.command, 2000)
                    applied = true
                  end
                end
              end
            end

            return applied
          end

          local function run_eslint(done)
            local clients = vim.lsp.get_clients { bufnr = bufnr, name = "eslint" }
            if #clients == 0 then
              done()
              return
            end

            if apply_code_action_sync("source.fixAll.eslint", vim.diagnostic.get(bufnr)) then
              done()
              return
            end

            local client = clients[1]
            local ok = pcall(function()
              client:exec_cmd({
                command = "eslint.executeAutofix",
                arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
              }, { bufnr = bufnr }, function()
                done()
              end)
            end)

            if not ok then done() end
          end

          local function run_ts_actions(done)
            if not is_ts then
              done()
              return
            end
            apply_code_action("source.addMissingImports.ts", {}, function()
              apply_code_action("source.removeUnused.ts", {}, done)
            end)
          end

          local function run_stylelint(done)
            local clients = vim.lsp.get_clients { bufnr = bufnr, name = "stylelint_lsp" }
            if not is_style or #clients == 0 then
              done()
              return
            end

            vim.lsp.buf.format {
              bufnr = bufnr,
              async = false,
              timeout_ms = 2000,
              filter = function(client) return client.name == "stylelint_lsp" end,
            }
            done()
          end

          local function run_conform()
            local ok = require("conform").format({
              async = false,
              lsp_format = "fallback",
              bufnr = bufnr,
            })
            if ok == false then vim.notify("Formatting failed", vim.log.levels.ERROR) end
          end

          run_eslint(function()
            run_ts_actions(function()
              run_stylelint(run_conform)
            end)
          end)
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
        dart = { "dart_format" },
        scss = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        json = { "jq" },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        yaml = { "prettierd" },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
