-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
-- config.font_size = 15
config.font_size = 18

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"

config.window_background_opacity = 1
-- config.macos_window_background_blur = 10

config.color_scheme_dirs = { '~/.config/wezterm/colorschemes' }

local my_catppucin = wezterm.color.get_builtin_schemes()['Catppuccin Frappe']
my_catppucin.cursor_bg = 'magenta'
my_catppucin.cursor_border = 'magenta'
my_catppucin.cursor_fg = 'white'

config.color_schemes = {
  ['My Catppuccin'] = my_catppucin,
}
config.color_scheme = 'My Catppuccin'
-- config.color_scheme = 'tokyonight_moon'

-- config.default_cursor_style = 'BlinkingBlock'

config.mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- and finally, return the configuration to wezterm
return config
