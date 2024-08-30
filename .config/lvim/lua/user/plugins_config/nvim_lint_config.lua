local M = {}

M.config = function ()
  local lint = require("lint")

  lint.linters_by_ft = {
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    html = { "eslint_d" },
    htmlangular = { "eslint_d" },
    css = { "stylelint" },
    scss = { "stylelint" },
  }

  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })
end

return M
