local M = {}

function M.setup()
  -- Diagnostic Configuration
  vim.diagnostic.config {
    severity_sort = true,
    float = {
      border = 'rounded',
      source = true,
    },
    underline = { severity = vim.diagnostic.severity.WARN },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = false,
    virtual_lines = false,
  }

  -- Custom diagnostic display on cursor line
  local ns = vim.api.nvim_create_namespace 'cursor_line_diagnostics'

  local function format_diagnostic(diagnostic)
    local diagnostic_message = {
      [vim.diagnostic.severity.ERROR] = diagnostic.message,
      [vim.diagnostic.severity.WARN] = diagnostic.message,
      [vim.diagnostic.severity.INFO] = diagnostic.message,
      [vim.diagnostic.severity.HINT] = diagnostic.message,
    }
    return diagnostic_message[diagnostic.severity] or diagnostic.message
  end

  local function show_line_diagnostics()
    local bufnr = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) or vim.bo[bufnr].buftype ~= '' then
      return
    end

    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

    vim.diagnostic.reset(ns, bufnr)

    local diags = vim.diagnostic.get(bufnr, { lnum = cursor_line })

    if #diags > 0 then
      local formatted_diags = {}
      for _, d in ipairs(diags) do
        local copy = vim.deepcopy(d)
        copy.message = format_diagnostic(copy)
        table.insert(formatted_diags, copy)
      end

      vim.diagnostic.show(ns, bufnr, formatted_diags, { virtual_lines = true })
    end
  end

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    callback = show_line_diagnostics,
  })
end

return M
