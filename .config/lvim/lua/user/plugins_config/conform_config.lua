local M = {}

M.config = function ()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      html = { "eslint", "prettierd" },
      htmlangular = { "eslint", "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      graphql = { "prettierd" },
      json = { "jq" },
      jsonc = { "jq" },
      lua = { "stylua" }
    }
  })
end

return M
