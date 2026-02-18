bindkey -v

bindkey '^R' atuin-up-search
bindkey '^n' autosuggest-accept

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_VISUAL=5

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '^F' sesh-sessions
bindkey -M vicmd '^F' sesh-sessions
bindkey -M viins '^F' sesh-sessions

# Copy selection to clipboard in vi mode
function zsh-copy-region-to-clipboard() {
  if [[ -z $REGION_ACTIVE ]]; then
    echo "Nothing selected"
    return
  fi
  echo -n "$CUTBUFFER" | pbcopy
  zle kill-region
}

zle -N zsh-copy-region-to-clipboard
bindkey -M vicmd 'y' zsh-copy-region-to-clipboard
