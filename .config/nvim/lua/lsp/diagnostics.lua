local M = {}

function M.setup()
  -- Filter out angularls diagnostics for unknown elements (-998001).
  -- These are false positives in Nx monorepos where internal libs are not
  -- installed as real node_modules packages (path aliases only).
  local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    if result and result.diagnostics then
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client and client.name == "angularls" then
        result.diagnostics = vim.tbl_filter(
          function(d) return d.code ~= -998001 and d.code ~= -998002 end,
          result.diagnostics
        )
      end
    end
    orig_handler(err, result, ctx, config)
  end

  -- Diagnostic Configuration
  vim.diagnostic.config {
    severity_sort = true,
    float = {
      border = "rounded",
      source = true,
    },
    underline = { severity = vim.diagnostic.severity.WARN },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
        [vim.diagnostic.severity.INFO] = "󰋽 ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
      },
    } or {},
    virtual_text = false,
    virtual_lines = false,
  }

  local diagnostic_float_group =
    vim.api.nvim_create_augroup("PersonalDiagnosticFloat", { clear = true })

  vim.api.nvim_create_autocmd("CursorHold", {
    desc = "Show line diagnostics in a floating window",
    group = diagnostic_float_group,
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      if vim.bo[bufnr].buftype ~= "" then return end

      local line = vim.api.nvim_win_get_cursor(0)[1] - 1
      if #vim.diagnostic.get(bufnr, { lnum = line }) == 0 then return end

      vim.diagnostic.open_float(bufnr, {
        scope = "line",
        focusable = false,
        close_events = { "BufHidden", "CursorMoved", "CursorMovedI", "InsertEnter" },
      })
    end,
  })
end

return M
