if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# zinit light MichaelAquilina/zsh-you-should-use
zinit load atuinsh/atuin

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::vi-mode
zinit snippet OMZP::thefuck
zinit snippet OMZP::colorize
zinit snippet OMZP::command-not-found

export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"
export NVM_AUTO_USE=true
# zinit wait lucid light-mode for lukechilds/zsh-nvm

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Atuin search instead of FZF
bindkey '^R' atuin-up-search

# Load completions
autoload -Uz compinit && compinit

bindkey '^n' autosuggest-accept

export TERM=xterm-256color-italic

export PATH="$HOME/.local/bin:$PATH"
# export EDITOR=lvim
export EDITOR=nvim

bindkey -v

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_VISUAL=5

export JIRA_URL="https://jira.devnet.klm.com"
export JIRA_NAME="T206002"

# PYENV
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# RBENV
eval "$(rbenv init - -zsh)"

# bun completions
[ -s "/Users/franckdelage/.bun/_bun" ] && source "/Users/franckdelage/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Deno/Altea
export PATH="$HOME/.deno/bin:$PATH"

# neovim
# export PATH="$HOME/.local/nvim/bin:$PATH"

# Starship
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/franckdelage/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# ALIASES
alias ec='$EDITOR $HOME/.zshrc'
alias sc='source $HOME/.zshrc'

alias cdc='cd ~ && clear'

alias vim='nvim'
# alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" /opt/homebrew/bin/nvim'

alias mux='tmuxinator start'

alias bw='tmuxinator start aviato-workspace'

alias smokerecord='clear && yarn nx run e2e:record'
alias smokereplay='clear && yarn nx run e2e:replay'
alias smokeheadless='clear && yarn nx run e2e:headless'
alias fakesession='clear && yarn nx run fake-session:serve'

alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias ll='eza -l --icons -h'
alias la='eza -l -a --icons -h'

alias nxg='yarn nx g'
alias nxgm='yarn nx g module'
alias nxgc='yarn nx g @ngneat/spectator:spectator-component'
alias nxgs='yarn nx g @ngneat/spectator:spectator-service'
alias nxgd='yarn nx g @ngneat/spectator:spectator-directive'

alias apirequests="cd ~/Developer && mkdir -p mitm-files && cd mitm-files && mitmproxy --listen-port=8080 --set view_filter='!beacon & !pharos' --set console_focus_follow=true --set console_default_contentview='json'"

alias appstart='yarn nx run touchpoint-web:serve:ute3'
alias gqlstart='HTTPS_PROXY=http://localhost:8080 NODE_TLS_REJECT_UNAUTHORIZED=0 FEATURE_ENV=localhost yarn nx run gql:serve:ute3'
alias serverstart='yarn nx run touchpoint-web:server:ute3'
alias exchangestart='yarn nx run exchange:serve:ute3'

alias gqlstartute2='HTTPS_PROXY=http://localhost:8080 NODE_TLS_REJECT_UNAUTHORIZED=0 FEATURE_ENV=localhost yarn nx run gql:serve:ute2'
alias serverstartute2='yarn nx run touchpoint-web:server:ute2'

alias introspect='(cd apps/gql && yarn graphql:introspect)'

alias nxr='clear && yarn nx run'

alias com='git commit'

alias -g wch='--watch'
alias -g noCov='--coverage false'
