local M = {}

M.config = function ()
  require("nvim-treesitter.install").prefer_git = true
  vim.treesitter.language.register("html", "htmlangular")
end

return M
