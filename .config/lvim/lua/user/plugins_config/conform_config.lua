local M = {}

M.config = function ()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      html = { "eslint_d", "prettierd" },
      htmlangular = { "eslint_d", "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      json = { "jq" },
    }
  })
end

return M
