# Linux-specific SDK settings.
typeset -U path PATH

android_sdk="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}}"
if [[ ! -d "$android_sdk" && -d "$HOME/Android/Sdk" ]]; then
  android_sdk="$HOME/Android/Sdk"
fi

if [[ -d "$android_sdk" ]]; then
  export ANDROID_HOME="$android_sdk"
  export ANDROID_SDK_ROOT="$android_sdk"
  [[ -d "$android_sdk/emulator" ]] && path=("$android_sdk/emulator" $path)
  [[ -d "$android_sdk/platform-tools" ]] && path=("$android_sdk/platform-tools" $path)
fi
