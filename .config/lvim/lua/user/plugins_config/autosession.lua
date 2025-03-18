local M = {}

M.config = function ()
  require("auto-session").setup({
    suppressed_dirs = { "~/", "~/Developer", "~/Downloads", "/"},
    bypass_save_filetypes = { 'alpha', 'dashboard' },
    auto_create = false,
  })
end

return M
