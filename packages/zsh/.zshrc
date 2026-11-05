ZDOTDIR="${ZDOTDIR:-$HOME}"

case "$OSTYPE" in
  darwin*)
    [[ -f "$ZDOTDIR/.zsh/env-macos.zsh" ]] && source "$ZDOTDIR/.zsh/env-macos.zsh"
    ;;
  linux*)
    [[ -f "$ZDOTDIR/.zsh/env-linux.zsh" ]] && source "$ZDOTDIR/.zsh/env-linux.zsh"
    ;;
esac

for config in "$ZDOTDIR"/.zsh/{env-interactive,plugins,history,completion,fzf,keybindings,languages,tools,aliases}.zsh; do
  [[ -f "$config" ]] && source "$config"
done

if [[ "$OSTYPE" == darwin* && -f "$ZDOTDIR/.zsh/work.zsh" ]]; then
  source "$ZDOTDIR/.zsh/work.zsh"
fi

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
