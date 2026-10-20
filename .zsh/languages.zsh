if [[ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]]; then
  autoload -U add-zsh-hook

  _load_nvm() {
    local nvm_command
    local -A lazy_functions
    # NVM invokes Node during initialization, so remove the wrappers first.
    for nvm_command in nvm node npm npx corepack yarn pnpm; do
      lazy_functions[$nvm_command]=${functions[$nvm_command]}
      unfunction "$nvm_command"
    done
    add-zsh-hook -d chpwd _load_nvm

    source "${NVM_DIR:-$HOME/.nvm}/nvm.sh" || {
      for nvm_command in ${(k)lazy_functions}; do
        functions[$nvm_command]=${lazy_functions[$nvm_command]}
      done
      add-zsh-hook chpwd _load_nvm
      print -u2 -- "Failed to initialize NVM"
      return 1
    }
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc || return 1
  }

  load-nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [[ -n "$nvmrc_path" ]]; then
      local nvmrc_node_version
      nvmrc_node_version=$(nvm version "$(<"$nvmrc_path")")

      if [[ "$nvmrc_node_version" == N/A ]]; then
        nvm install
      elif [[ "$nvmrc_node_version" != "$(nvm version)" ]]; then
        nvm use
      fi
    elif [[ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ]] && [[ "$(nvm version)" != "$(nvm version default)" ]]; then
      print -r -- "Reverting to nvm default version"
      nvm use default
    fi
  }

  for nvm_command in nvm node npm npx corepack yarn pnpm; do
    functions[$nvm_command]='_load_nvm || return 1; "$0" "$@"'
  done
  unset nvm_command

  add-zsh-hook -d chpwd load-nvmrc
  add-zsh-hook chpwd _load_nvm
fi

if (( $+commands[pyenv] )); then
  eval "$(pyenv init - --no-rehash zsh)"
fi

if (( $+commands[rbenv] )); then
  eval "$(rbenv init - --no-rehash zsh)"
fi
