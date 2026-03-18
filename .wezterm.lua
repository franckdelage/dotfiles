local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.quick_select_patterns = {
  'Bearer\\s([a-zA-Z0-9]+)',
  '\\s([A-Z0-9]{6})$',
}

config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  {
    key = 'q',
    mods = 'LEADER',
    action = wezterm.action.QuitApplication,
  },
  {
    key = 'b',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 'b', mods = 'CTRL' },
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode,
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.QuickSelect,
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = wezterm.action.ActivateCommandPalette,
  },
}

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
