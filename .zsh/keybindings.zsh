bindkey -v

(( $+widgets[atuin-up-search] )) && bindkey '^R' atuin-up-search
(( $+widgets[autosuggest-accept] )) && bindkey '^n' autosuggest-accept
bindkey '^[f' forward-word

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_VISUAL=5

if (( $+commands[sesh] && $+commands[fzf] )); then
  sesh-sessions() {
    {
      exec </dev/tty
      exec <&1
      local session
      session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
      zle reset-prompt > /dev/null 2>&1 || true
      [[ -z "$session" ]] && return 0
      sesh connect "$session"
    }
  }

  zle -N sesh-sessions
  bindkey -M emacs '^F' sesh-sessions
  bindkey -M vicmd '^F' sesh-sessions
  bindkey -M viins '^F' sesh-sessions
fi

if (( $+commands[pbcopy] )); then
  _zsh_copy_to_clipboard() {
    command pbcopy
  }
elif (( $+commands[wl-copy] )); then
  _zsh_copy_to_clipboard() {
    command wl-copy
  }
fi

if (( $+functions[_zsh_copy_to_clipboard] )); then
  zsh-copy-region-to-clipboard() {
    if [[ -z $REGION_ACTIVE ]]; then
      print -r -- "Nothing selected"
      return 1
    fi

    printf '%s' "$CUTBUFFER" | _zsh_copy_to_clipboard
    zle kill-region
  }

  zle -N zsh-copy-region-to-clipboard
  bindkey -M vicmd 'y' zsh-copy-region-to-clipboard
fi
