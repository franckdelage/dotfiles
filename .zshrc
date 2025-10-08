if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZDOTDIR="${ZDOTDIR:-$HOME}"

for config in "$ZDOTDIR"/.zsh/{env,plugins,history,completion,keybindings,languages,tools,aliases,work}.zsh; do
  [ -f "$config" ] && source "$config"
done

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

export PATH="/Users/franckdelage/.rd/bin:$PATH"
