alias ec='$EDITOR $HOME/.zshrc'
alias sc='source $HOME/.zshrc'

if (( $+commands[zoxide] )); then
  alias cd='j'
  alias cdc='j ~ && clear'
fi

if (( $+commands[nvim] )); then
  alias vim='nvim'
  alias v='nvim'
fi

if (( $+commands[tmuxinator] )); then
  alias mux='tmuxinator start'
  alias bw='tmuxinator start aviato-workspace'
fi

if (( $+commands[eza] )); then
  alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
  alias ll='eza -l --icons -h'
  alias la='eza -l -a --icons -h'
fi

alias com='git commit'
(( $+commands[delta] )) && alias gdiff='git diff | delta --side-by-side'

alias -g wch='--watch'
alias -g noCov='--coverage false'

if (( $+commands[eza] && $+commands[zoxide] )); then
  alias zad='eza -D1 --icons=never | xargs -I {} zoxide add {}'
fi
