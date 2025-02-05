local M = {}

M.config = function ()
  require("aerial").setup({
    filter_kind = false,
  })
end

return M
