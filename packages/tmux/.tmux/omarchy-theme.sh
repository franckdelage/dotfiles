#!/usr/bin/env bash

set -eu

if [ "$#" -ne 0 ]; then
  if [ "$#" -ne 2 ] || { [ "$1" != -L ] && [ "$1" != -S ]; }; then
    printf 'Usage: omarchy-theme.sh [-L socket-name | -S socket-path]\n' >&2
    exit 1
  fi
fi
socket_option=${1-}
socket_value=${2-}

tmux_command() {
  if [ -n "$socket_option" ]; then
    tmux "$socket_option" "$socket_value" "$@" || return 1
  else
    tmux "$@" || return 1
  fi
}

# A theme change must not start a server when tmux is not running.
if ! tmux_command list-sessions >/dev/null 2>&1; then
  exit 0
fi

read_color() {
  key=$1
  fallback=$2
  value=''
  if command -v omarchy-theme-color >/dev/null 2>&1; then
    value=$(omarchy-theme-color "$key" 2>/dev/null) || value=''
    if [ -z "$value" ] && [ "$key" = accent ]; then
      value=$(omarchy-theme-color blue 2>/dev/null) || value=''
    fi
  fi
  case "$value" in
    \#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])
      printf '%s' "$value"
      ;;
    *)
      printf 'Cannot read theme color %s. Use the fallback %s.\n' "$key" "$fallback" >&2
      printf '%s' "$fallback"
      ;;
  esac
}

background=$(read_color background '#1e1e2e')
foreground=$(read_color foreground '#cdd6f4')
accent=$(read_color accent '#89b4fa')
muted=$(read_color muted '#6c7086')
selection=$(read_color selection '#45475a')

tmux_command set-option -g status-style "bg=$background,fg=$foreground"
tmux_command set-option -g status-left "#[fg=$background,bg=$accent,bold] #S #[default] "
tmux_command set-option -g status-right "#[fg=$muted]#{?pane_in_mode,COPY ,}#{?client_prefix,PREFIX ,}#{?window_zoomed_flag,ZOOM ,}#{pane_current_command} | %H:%M #[default]"
tmux_command set-option -g window-status-separator ''
tmux_command set-option -g window-status-format "#[fg=$muted] #I:#W "
tmux_command set-option -g window-status-current-format "#[fg=$accent,bold] #I:#W "
tmux_command set-option -g window-status-style "bg=$background,fg=$muted"
tmux_command set-option -g window-status-current-style "bg=$background,fg=$accent,bold"
tmux_command set-option -g pane-border-style "fg=$muted"
tmux_command set-option -g pane-active-border-style "fg=$accent"
tmux_command set-option -g message-style "bg=$selection,fg=$foreground"
tmux_command set-option -g message-command-style "bg=$selection,fg=$foreground"
tmux_command set-option -g mode-style "bg=$selection,fg=$foreground"
tmux_command set-option -g clock-mode-colour "$accent"
