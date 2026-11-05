#!/usr/bin/env bash

set -eu

# Omarchy passes the theme name. The shared script reads the active palette.
# Target the standard server even when the hook runs from another tmux socket.
exec bash "$HOME/.tmux/omarchy-theme.sh" -L default
