-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 13

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.86
-- config.macos_window_background_blur = 10

local my_catppucin = wezterm.color.get_builtin_schemes()['Catppuccin Frappe']
my_catppucin.cursor_bg = 'magenta'
my_catppucin.cursor_border = 'magenta'
my_catppucin.cursor_fg = 'white'

config.color_schemes = {
  ['My Catppuccin'] = my_catppucin,
}
config.color_scheme = 'My Catppuccin'

config.default_cursor_style = 'BlinkingBlock'

-- and finally, return the configuration to wezterm
return config
