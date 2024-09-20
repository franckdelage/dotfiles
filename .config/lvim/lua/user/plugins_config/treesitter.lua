local M = {}

M.config = function ()
  -- require("nvim-treesitter.install").prefer_git = true
  vim.treesitter.language.register("html", "htmlangular")
  vim.treesitter.language.register("bash", "zsh")
end

return M
