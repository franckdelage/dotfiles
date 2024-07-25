local M = {}

M.config = function ()
  require('lspsaga').setup({
    definition = {
      width = 0.8,
      height = 0.8,
    },
    symbol_in_winbar = {
      enable = false,
      show_file = false,
    },
    lightbulb = {
      enable = false,
    },
  })
end

return M
