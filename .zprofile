# Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Login environment (generic env vars)
source "$HOME/.zsh/env-login.zsh"

# NVM
export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"
export NVM_AUTO_USE=true
export NVM_DIR="$HOME/.nvm"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# Rancher Desktop
export PATH="/Users/franckdelage/.rd/bin:$PATH"
