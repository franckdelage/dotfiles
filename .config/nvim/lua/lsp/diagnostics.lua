local M = {}

function M.setup()
  -- Diagnostic Configuration
  local diagnostic_icons = {
    [vim.diagnostic.severity.ERROR] = "󰅚",
    [vim.diagnostic.severity.WARN] = "󰀪",
    [vim.diagnostic.severity.INFO] = "󰋽",
    [vim.diagnostic.severity.HINT] = "󰌶",
  }

  vim.diagnostic.config {
    severity_sort = true,
    float = {
      border = "rounded",
      source = true,
    },
    underline = { severity = vim.diagnostic.severity.WARN },
    signs = vim.g.have_nerd_font and {
      text = diagnostic_icons,
    } or {},
    virtual_text = {
      current_line = true,
      spacing = 2,
      source = "if_many",
      prefix = function(diagnostic)
        if vim.g.have_nerd_font then return diagnostic_icons[diagnostic.severity] end
        return "●"
      end,
    },
    virtual_lines = false,
  }
end

return M
