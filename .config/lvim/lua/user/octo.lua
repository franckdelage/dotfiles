local M = {}

M.config = function ()
  require "octo".setup({
    enable_builtin = true,
    default_remote = { "github", "origin" },
  })
  vim.cmd([[hi OctoEditable guibg=none]])
end

return M
