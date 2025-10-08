ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit load atuinsh/atuin

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::vi-mode
zinit snippet OMZP::thefuck
zinit snippet OMZP::colorize
zinit snippet OMZP::command-not-found
