typeset -U path PATH

if [[ -f "$HOME/.zsh/env-login.zsh" ]]; then
  source "$HOME/.zsh/env-login.zsh"
fi

export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT=true
export NVM_AUTO_USE=true
export NVM_DIR="$HOME/.nvm"

export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL/bin" ]] && path=("$BUN_INSTALL/bin" $path)
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

[[ -d "$HOME/.deno/bin" ]] && path=("$HOME/.deno/bin" $path)

case "$OSTYPE" in
  darwin*)
    [[ -f "$HOME/.zsh/env-macos.zsh" ]] && source "$HOME/.zsh/env-macos.zsh"
    ;;
  linux*)
    [[ -f "$HOME/.zsh/env-linux.zsh" ]] && source "$HOME/.zsh/env-linux.zsh"
    ;;
esac
