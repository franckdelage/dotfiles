if (( ! $+commands[fzf] )); then
  return 0
fi

fzf_zsh_init="$(fzf --zsh 2>/dev/null)" || return 0
[[ -n "$fzf_zsh_init" ]] || return 0
eval "$fzf_zsh_init"
unset fzf_zsh_init

if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }
fi

[[ -f "$HOME/fzf-git.sh/fzf-git.sh" ]] && source "$HOME/fzf-git.sh/fzf-git.sh"

show_file_or_dir_preview=""
if (( $+commands[eza] && $+commands[bat] )); then
  show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
  export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
elif (( $+commands[eza] )); then
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
fi

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

if (( $+widgets[fzf-history-widget] )); then
  fzf-history-widget-accept() {
    fzf-history-widget
    zle accept-line
  }
  zle -N fzf-history-widget-accept
  bindkey '^X^R' fzf-history-widget-accept
fi

if [[ -n "$show_file_or_dir_preview" ]]; then
  _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
      cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
      export|unset) fzf --preview "eval 'echo ${}'" "$@" ;;
      ssh)          fzf --preview 'dig {}' "$@" ;;
      *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
    esac
  }
fi

export FZF_DEFAULT_OPTS=" \
--color=bg+:#2d3f76,bg:#222436,spinner:#c099ff,hl:#ff966c \
--color=fg:#c8d3f5,header:#ff966c,info:#82aaff,pointer:#c099ff \
--color=marker:#c099ff,fg+:#c8d3f5,prompt:#82aaff,hl+:#ff966c \
--color=selected-bg:#2d3f76 \
--multi"
