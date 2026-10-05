local omarchy_theme = require("omarchy_theme").current
local use_tokyonight = omarchy_theme
  and omarchy_theme.colorscheme:match("^tokyonight") ~= nil

return {
  'folke/tokyonight.nvim',
  lazy = not use_tokyonight,
  priority = use_tokyonight and 1000 or nil,
  config = function()
    require('tokyonight').setup {
      style = 'moon',
      dim_inactive = true,
      lualine_bold = true,
    }

    -- vim.cmd.colorscheme 'tokyonight'
    -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    -- vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  end,
}
