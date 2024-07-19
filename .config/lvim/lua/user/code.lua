local M = {}

M.config = function ()
  local linters = require "lvim.lsp.null-ls.linters"
  linters.setup {
    {
      name = "eslint_d",
      filetypes = { "typescript", "javascript", "html" }
    },
    { name = "stylelint" },
  }

  local code_actions = require "lvim.lsp.null-ls.code_actions"
  code_actions.setup {
    {
      name = "eslint_d",
      filetypes = { "typescript", "javascript", "html" }
    },
  }

  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup {
    { name = "eslint_d" },
    -- { name = "prettierd" },
  }
end

return M
