#!/usr/bin/env bash

set -eu

# The final marker keeps command substitution from removing trailing newlines.
buf=$(cat "$@" && printf '.')
buf=${buf%.}

if command -v pbcopy >/dev/null 2>&1; then
  if command -v reattach-to-user-namespace >/dev/null 2>&1; then
    printf '%s' "$buf" | reattach-to-user-namespace pbcopy
  else
    printf '%s' "$buf" | pbcopy
  fi
  exit 0
fi

# Prefer the native Wayland clipboard over XWayland tools.
if [ -n "${WAYLAND_DISPLAY-}" ] && command -v wl-copy >/dev/null 2>&1; then
  printf '%s' "$buf" | wl-copy
  exit 0
fi

if [ -n "${DISPLAY-}" ] && command -v xsel >/dev/null 2>&1; then
  printf '%s' "$buf" | xsel -i --clipboard
  exit 0
fi

if [ -n "${DISPLAY-}" ] && command -v xclip >/dev/null 2>&1; then
  printf '%s' "$buf" | xclip -i -selection primary
  printf '%s' "$buf" | xclip -i -selection clipboard
  exit 0
fi

copy_use_osc52_fallback=$(tmux show-option -gvq '@copy_use_osc52_fallback')
if [ "$copy_use_osc52_fallback" = off ]; then
  exit 0
fi

# OSC 52 permits at most 74,994 input bytes in a 100,000-byte sequence.
buflen=$(printf '%s' "$buf" | wc -c)
maxlen=74994
if [ "$buflen" -gt "$maxlen" ]; then
  printf 'input is %d bytes too long\n' "$((buflen - maxlen))" >&2
fi

encoded=$(printf '%s' "$buf" | head -c "$maxlen" | base64 | tr -d '\r\n')
pane_tty=$(tmux display-message -p '#{pane_tty}')
target_tty=${SSH_TTY:-$pane_tty}
if [ -z "$target_tty" ]; then
  printf 'No terminal is available for OSC 52 copy.\n' >&2
  exit 1
fi

printf '\033Ptmux;\033\033]52;c;%s\a\033\134' "$encoded" > "$target_tty"
