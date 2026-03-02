ZDOTDIR="${ZDOTDIR:-$HOME}"

for config in "$ZDOTDIR"/.zsh/{env-interactive,plugins,history,completion,fzf,keybindings,languages,tools,aliases,work}.zsh; do
  [ -f "$config" ] && source "$config"
done

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
