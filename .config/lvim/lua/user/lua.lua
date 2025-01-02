local M = {}

M.config = function ()
  local capabilities = require("blink.cmp").get_lsp_capabilities()
  require'lspconfig'.lua_ls.setup{
    capabilities = capabilities,
  }
end

return M
