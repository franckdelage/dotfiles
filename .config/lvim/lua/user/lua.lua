local M = {}

M.config = function ()
  require'lspconfig'.lua_ls.setup{}
end

return M
