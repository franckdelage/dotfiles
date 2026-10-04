# macOS-specific paths and SDK settings.
typeset -U path PATH

for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "$brew_path" ]]; then
    eval "$("$brew_path" shellenv)"
    break
  fi
done

if [[ -d "$HOME/.rd/bin" ]]; then
  path=("$HOME/.rd/bin" $path)
fi

android_sdk="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
if [[ ! -d "$android_sdk" && -d "$HOME/Library/Android/sdk" ]]; then
  android_sdk="$HOME/Library/Android/sdk"
fi

if [[ -d "$android_sdk" ]]; then
  export ANDROID_HOME="$android_sdk"
  export ANDROID_SDK_ROOT="$android_sdk"
  [[ -d "$android_sdk/emulator" ]] && path=("$android_sdk/emulator" $path)
  [[ -d "$android_sdk/platform-tools" ]] && path=("$android_sdk/platform-tools" $path)
fi
