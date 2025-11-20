alias ec='$EDITOR $HOME/.zshrc'
alias sc='source $HOME/.zshrc'

alias cd='j'
alias cdc='j ~ && clear'

alias vim='nvim'

alias mux='tmuxinator start'
alias bw='tmuxinator start aviato-workspace'

alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias ll='eza -l --icons -h'
alias la='eza -l -a --icons -h'

alias com='git commit'

alias -g wch='--watch'
alias -g noCov='--coverage false'

alias zad='eza -D1 --icons=never | xargs -I {} zoxide add {}'
