ZINIT_HOME="${ZINIT_HOME:-${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git}"

if [[ ! -s "$ZINIT_HOME/zinit.zsh" ]]; then
  if [[ ! -e "$ZINIT_HOME" ]] && (( $+commands[git] )); then
    command mkdir -p "${ZINIT_HOME:h}"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  fi
fi

[[ -s "$ZINIT_HOME/zinit.zsh" ]] || return 0
source "$ZINIT_HOME/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
(( $+commands[atuin] )) && zinit load atuinsh/atuin

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::vi-mode
zinit snippet OMZP::colorize
zinit snippet OMZP::command-not-found
