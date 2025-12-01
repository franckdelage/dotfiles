local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrainsMono Nerd Font Mono")

-- config.font_size = 15
config.font_size = 18

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"

config.window_background_opacity = 1
-- config.color_scheme = 'Tokyo Night Moon'
config.color_scheme = 'Kanagawa (Gogh)'

config.colors = {
  cursor_bg = 'magenta',
  cursor_fg = 'white',
  cursor_border = 'magenta',
}

config.mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

return config
