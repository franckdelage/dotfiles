local omarchy_theme = require("omarchy_theme").current
local use_catppuccin = omarchy_theme
  and omarchy_theme.colorscheme:match("^catppuccin") ~= nil

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  enabled = use_catppuccin,
  lazy = not use_catppuccin,
}
