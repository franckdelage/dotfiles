#!/usr/bin/env bash
set -eo pipefail

DOTFILES_SOURCE="$(cd "$(dirname "$0")/.." && pwd -P)"
STOW_BIN="$(command -v stow)"
[ -n "$STOW_BIN" ] || { printf 'GNU Stow is required for this test.\n' >&2; exit 77; }
WORK="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-tests.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT HUP INT TERM
REPO="$WORK/dotfiles repo"
mkdir -p "$REPO/packages" "$WORK/bin"
cp "$DOTFILES_SOURCE/dotfiles.sh" "$REPO/dotfiles.sh"
chmod +x "$REPO/dotfiles.sh"

mkdir -p "$REPO/packages/nvim/.config/nvim" "$REPO/packages/herdr/.config/herdr"
mkdir -p "$REPO/packages/ghostty/.config/ghostty" "$REPO/packages/wezterm/.config/wezterm/colorshemes"
mkdir -p "$REPO/packages/macos-karabiner/.config/karabiner" "$REPO/packages/omarchy-shell/.config/omarchy"
mkdir -p "$REPO/packages/sesh/.config/sesh"
mkdir -p "$REPO/packages/omarchy-hyprland/.config/hypr"
printf 'return true\n' > "$REPO/packages/omarchy-hyprland/.config/hypr/input.lua"
printf 'return true\n' > "$REPO/packages/omarchy-hyprland/.config/hypr/looknfeel.lua"
mkdir -p "$REPO/packages/macos-karabiner/.config/karabiner" "$REPO/archive/macos-karabiner/automatic_backups"
printf 'return true\n' > "$REPO/packages/nvim/.config/nvim/init.lua"
printf 'host = true\n' > "$REPO/packages/herdr/.config/herdr/config.toml"
printf 'theme = \"test\"\n' > "$REPO/packages/ghostty/.config/ghostty/config"
printf 'return true\n' > "$REPO/packages/wezterm/.wezterm.lua"
printf 'name = \"test\"\n' > "$REPO/packages/wezterm/.config/wezterm/colorshemes/theme.toml"
printf '{ }\n' > "$REPO/packages/macos-karabiner/.config/karabiner/karabiner.json"
printf 'backup\n' > "$REPO/archive/macos-karabiner/automatic_backups/backup.json"
printf '{ }\n' > "$REPO/packages/omarchy-shell/.config/omarchy/shell.json"
printf 'linux = true\n' > "$REPO/packages/sesh/.config/sesh/sesh-linux.toml"
printf 'macos = true\n' > "$REPO/packages/sesh/.config/sesh/sesh-macos.toml"
printf '^/\\.config/sesh/sesh\\.toml$\n' > "$REPO/packages/sesh/.stow-local-ignore"
printf 'legacy\tnew\tpackage\tdisposition\n' > "$REPO/packages/migration-map.tsv"
printf '.config/nvim/init.lua\tpackages/nvim/.config/nvim/init.lua\tnvim\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/ghostty/config\tpackages/ghostty/.config/ghostty/config\tghostty\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.wezterm.lua\tpackages/wezterm/.wezterm.lua\twezterm\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/wezterm/colorshemes/theme.toml\tpackages/wezterm/.config/wezterm/colorshemes/theme.toml\twezterm\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/sesh/sesh-linux.toml\tpackages/sesh/.config/sesh/sesh-linux.toml\tsesh\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/sesh/sesh-macos.toml\tpackages/sesh/.config/sesh/sesh-macos.toml\tsesh\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/karabiner/karabiner.json\tpackages/macos-karabiner/.config/karabiner/karabiner.json\tmacos-karabiner\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/herdr/config.toml\tpackages/herdr/.config/herdr/config.toml\therdr\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/hypr/bindings.lua\tarchive/omarchy-hyprland/bindings.lua\tomarchy-hyprland\tignored-screens\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/hypr/input.lua\tpackages/omarchy-hyprland/.config/hypr/input.lua\tomarchy-hyprland\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/hypr/looknfeel.lua\tpackages/omarchy-hyprland/.config/hypr/looknfeel.lua\tomarchy-hyprland\tmanaged\n' >> "$REPO/packages/migration-map.tsv"
printf '.config/hypr/monitors.lua\tarchive/omarchy-hyprland/monitors.lua\tomarchy-hyprland\tignored-screens\n' >> "$REPO/packages/migration-map.tsv"

HOME_TEST="$WORK/home with spaces"
mkdir -p "$HOME_TEST/.config/sesh"
printf 'local sesh data\n' > "$HOME_TEST/.config/sesh/sesh.toml"
printf 'local zsh data\n' > "$HOME_TEST/.zshrc.local"

# Selective stow/unstow must leave neighboring packages and local files alone.
HOME="$HOME_TEST" "$REPO/dotfiles.sh" stow --dry-run nvim >/dev/null
[ ! -e "$HOME_TEST/.config/nvim/init.lua" ] || { echo 'dry-run changed HOME'; exit 1; }
HOME="$HOME_TEST" "$REPO/dotfiles.sh" stow nvim >/dev/null
[ -L "$HOME_TEST/.config/nvim" ]
mkdir -p "$REPO/packages/nvim/.config/nvim/lua/plugins"
printf 'return true\n' > "$REPO/packages/nvim/.config/nvim/lua/plugins/new-plugin.lua"
[ -e "$HOME_TEST/.config/nvim/lua/plugins/new-plugin.lua" ]
HOME="$HOME_TEST" "$REPO/dotfiles.sh" stow herdr >/dev/null
CHECK_OUTPUT="$(HOME="$HOME_TEST" "$REPO/dotfiles.sh" check)"
[[ "$CHECK_OUTPUT" == *"OK      herdr"* ]]
[ -L "$HOME_TEST/.config/herdr" ]
HOME="$HOME_TEST" "$REPO/dotfiles.sh" stow sesh >/dev/null
[ ! -L "$HOME_TEST/.config/sesh" ]
[ -L "$HOME_TEST/.config/sesh/sesh-linux.toml" ]
HOME="$HOME_TEST" "$REPO/dotfiles.sh" unstow nvim >/dev/null
[ ! -e "$HOME_TEST/.config/nvim/init.lua" ]
[ -L "$HOME_TEST/.config/herdr" ]
[ "$(<"$HOME_TEST/.config/sesh/sesh.toml")" = 'local sesh data' ]
[ "$(<"$HOME_TEST/.zshrc.local")" = 'local zsh data' ]

LOCAL_NI_HOME="$WORK/local nvim home"
mkdir -p "$LOCAL_NI_HOME/.config/nvim"
printf 'machine-only\n' > "$LOCAL_NI_HOME/.config/nvim/local-only.lua"
mkdir -p "$LOCAL_NI_HOME/.config/nvim/scripts"
printf 'machine script\n' > "$LOCAL_NI_HOME/.config/nvim/scripts/local.py"
HOME="$LOCAL_NI_HOME" "$REPO/dotfiles.sh" stow nvim >/dev/null
[ ! -L "$LOCAL_NI_HOME/.config/nvim" ]
[ -L "$LOCAL_NI_HOME/.config/nvim/init.lua" ]
[ "$(<"$LOCAL_NI_HOME/.config/nvim/local-only.lua")" = 'machine-only' ]
HOME="$LOCAL_NI_HOME" "$REPO/dotfiles.sh" unstow nvim >/dev/null
[ "$(<"$LOCAL_NI_HOME/.config/nvim/local-only.lua")" = 'machine-only' ]

# A local conflict stops before changing existing content.
mkdir -p "$HOME_TEST/.config/nvim"
printf 'keep me\n' > "$HOME_TEST/.config/nvim/init.lua"
if HOME="$HOME_TEST" "$REPO/dotfiles.sh" stow nvim >/dev/null 2>&1; then echo 'local conflict was not rejected'; exit 1; fi
[ "$(<"$HOME_TEST/.config/nvim/init.lua")" = 'keep me' ]
rm "$HOME_TEST/.config/nvim/init.lua"
printf 'foreign\n' > "$WORK/foreign-file"
ln -s "$WORK/foreign-file" "$HOME_TEST/.config/nvim/init.lua"
if HOME="$HOME_TEST" "$REPO/dotfiles.sh" stow nvim >/dev/null 2>&1; then echo 'foreign symlink conflict was not rejected'; exit 1; fi
[ "$(readlink "$HOME_TEST/.config/nvim/init.lua")" = "$WORK/foreign-file" ]
rm "$HOME_TEST/.config/nvim/init.lua"

# OS guards are tested with a small uname shim and a PATH without Omarchy.
cat > "$WORK/bin/uname" <<'EOF'
#!/bin/sh
printf '%s\n' "${TEST_UNAME:-Linux}"
EOF
chmod +x "$WORK/bin/uname"
TEST_PATH="$WORK/bin:/usr/bin:/bin"
if HOME="$HOME_TEST" OMARCHY_PATH= PATH="$TEST_PATH" "$REPO/dotfiles.sh" stow macos-karabiner >/dev/null 2>&1; then echo 'macOS package accepted on Linux'; exit 1; fi
if HOME="$HOME_TEST" OMARCHY_PATH= PATH="$TEST_PATH" "$REPO/dotfiles.sh" stow omarchy-shell >/dev/null 2>&1; then echo 'Omarchy package accepted outside Omarchy'; exit 1; fi
TEST_UNAME=Darwin HOME="$HOME_TEST" OMARCHY_PATH= PATH="$TEST_PATH" "$REPO/dotfiles.sh" stow macos-karabiner >/dev/null
[ -L "$HOME_TEST/.config/karabiner" ]
[ ! -e "$HOME_TEST/.config/karabiner/automatic_backups/backup.json" ]
# Screens-generated Hyprland files stay local while static overrides stow.
mkdir -p "$WORK/omarchy-env" "$WORK/omarchy-home/.config/hypr"
printf 'screens binding\n' > "$WORK/omarchy-home/.config/hypr/bindings.lua"
printf 'screens layout\n' > "$WORK/omarchy-home/.config/hypr/monitors.lua"
OMARCHY_PATH="$WORK/omarchy-env" HOME="$WORK/omarchy-home" PATH="$TEST_PATH" "$REPO/dotfiles.sh" stow --dry-run omarchy-hyprland >/dev/null
OMARCHY_PATH="$WORK/omarchy-env" HOME="$WORK/omarchy-home" PATH="$TEST_PATH" "$REPO/dotfiles.sh" stow omarchy-hyprland >/dev/null
[ -L "$WORK/omarchy-home/.config/hypr/input.lua" ]
[ -L "$WORK/omarchy-home/.config/hypr/looknfeel.lua" ]
OMARCHY_CHECK="$(OMARCHY_PATH="$WORK/omarchy-env" HOME="$WORK/omarchy-home" PATH="$TEST_PATH" "$REPO/dotfiles.sh" check)"
[[ "$OMARCHY_CHECK" == *"OK      omarchy-hyprland"* ]]
OMARCHY_PATH="$WORK/omarchy-env" HOME="$WORK/omarchy-home" PATH="$TEST_PATH" "$REPO/dotfiles.sh" unstow omarchy-hyprland >/dev/null
[ ! -e "$WORK/omarchy-home/.config/hypr/input.lua" ]
[ "$(<"$WORK/omarchy-home/.config/hypr/bindings.lua")" = 'screens binding' ]
[ "$(<"$WORK/omarchy-home/.config/hypr/monitors.lua")" = 'screens layout' ]

# Legacy migration recognizes absolute directory links, relative dangling links,
# and partial packages without enabling files that were not active before.
MIGRATE_HOME="$WORK/migrate home"
mkdir -p "$MIGRATE_HOME/.config/sesh" "$MIGRATE_HOME/.config/ghostty" "$MIGRATE_HOME/.config/karabiner" "$REPO/.config/nvim" "$REPO/.config/ghostty" "$REPO/.config/karabiner"
printf 'local session\n' > "$MIGRATE_HOME/.config/sesh/sesh.toml"
printf 'machine shell\n' > "$MIGRATE_HOME/.zshrc.local"
printf 'return true\n' > "$REPO/.config/nvim/init.lua"
printf 'preserve this local file\n' > "$REPO/.config/nvim/local-not-managed.txt"
printf 'theme = \"test\"\n' > "$REPO/.config/ghostty/config"
printf '{ }\n' > "$REPO/.config/karabiner/karabiner.json"
ln -s "$REPO/.config/nvim" "$MIGRATE_HOME/.config/nvim"
ln -s '../../../dotfiles repo/.config/ghostty/config' "$MIGRATE_HOME/.config/ghostty/config"
ln -s '../../../dotfiles repo/.config/karabiner/karabiner.json' "$MIGRATE_HOME/.config/karabiner/karabiner.json"
rm "$REPO/.config/ghostty/config"
ln -s "$REPO/.wezterm.lua" "$MIGRATE_HOME/.wezterm.lua"
HOME="$MIGRATE_HOME" "$REPO/dotfiles.sh" migrate --dry-run > "$WORK/dry-run.log"
[ -L "$MIGRATE_HOME/.config/nvim" ]
[ ! -e "$MIGRATE_HOME/.config/wezterm/colorshemes/theme.toml" ]
OUTPUT="$(HOME="$MIGRATE_HOME" "$REPO/dotfiles.sh" migrate)"
BACKUP="$(printf '%s\n' "$OUTPUT" | awk -F 'Backup: ' '/^Backup: / {print $2}')"
[ -n "$BACKUP" ] && [ -d "$BACKUP" ]
[ -L "$MIGRATE_HOME/.config/nvim/init.lua" ]
[ -L "$MIGRATE_HOME/.config/ghostty" ]
[ -L "$MIGRATE_HOME/.wezterm.lua" ]
[ ! -e "$MIGRATE_HOME/.config/wezterm/colorshemes/theme.toml" ]
[ -L "$MIGRATE_HOME/.config/karabiner/karabiner.json" ]
[ "$(readlink "$MIGRATE_HOME/.config/karabiner/karabiner.json")" = '../../../dotfiles repo/.config/karabiner/karabiner.json' ]
[ "$(<"$MIGRATE_HOME/.config/nvim/local-not-managed.txt")" = 'preserve this local file' ]
[ "$(<"$MIGRATE_HOME/.config/sesh/sesh.toml")" = 'local session' ]
[ "$(<"$MIGRATE_HOME/.zshrc.local")" = 'machine shell' ]
rm "$MIGRATE_HOME/.config/nvim/local-not-managed.txt"
HOME="$MIGRATE_HOME" "$REPO/dotfiles.sh" migrate > "$WORK/idempotent.log"
grep -q 'No compatible legacy links' "$WORK/idempotent.log"
[[ "$(readlink "$MIGRATE_HOME/.wezterm.lua")" != /* ]]
HOME="$MIGRATE_HOME" "$REPO/dotfiles.sh" stow --dry-run wezterm >/dev/null
HOME="$MIGRATE_HOME" "$REPO/dotfiles.sh" unstow wezterm >/dev/null
[ ! -e "$MIGRATE_HOME/.wezterm.lua" ]
HOME="$MIGRATE_HOME" "$REPO/dotfiles.sh" rollback "$BACKUP" >/dev/null
[ -L "$MIGRATE_HOME/.config/nvim" ]
[ -L "$MIGRATE_HOME/.config/ghostty/config" ]
[ -L "$MIGRATE_HOME/.wezterm.lua" ]

FULL_MIGRATE_HOME="$WORK/full migration home"
mkdir -p "$FULL_MIGRATE_HOME/.config"
rm "$REPO/.config/nvim/local-not-managed.txt"
ln -s "$REPO/.config/nvim" "$FULL_MIGRATE_HOME/.config/nvim"
if ! FULL_MIGRATE_OUTPUT="$(HOME="$FULL_MIGRATE_HOME" "$REPO/dotfiles.sh" migrate)"; then
  printf '%s\n' "$FULL_MIGRATE_OUTPUT" >&2
  exit 1
fi
FULL_MIGRATE_BACKUP="$(printf '%s\n' "$FULL_MIGRATE_OUTPUT" | awk -F 'Backup: ' '/^Backup: / {print $2}')"
[ -n "$FULL_MIGRATE_BACKUP" ] && [ -d "$FULL_MIGRATE_BACKUP" ]
[ -L "$FULL_MIGRATE_HOME/.config/nvim" ]
FULL_MIGRATE_CHECK="$(HOME="$FULL_MIGRATE_HOME" "$REPO/dotfiles.sh" check)"
[[ "$FULL_MIGRATE_CHECK" == *"OK      nvim"* ]]
HOME="$FULL_MIGRATE_HOME" "$REPO/dotfiles.sh" rollback "$FULL_MIGRATE_BACKUP" >/dev/null
[ -L "$FULL_MIGRATE_HOME/.config/nvim" ]

# A changed file materialized from an old directory link is a conflict, not data
# to overwrite or delete.
CONFLICT_HOME="$WORK/conflict home"
mkdir -p "$CONFLICT_HOME/.config"
printf 'local edit\n' > "$REPO/.config/nvim/init.lua"
ln -s "$REPO/.config/nvim" "$CONFLICT_HOME/.config/nvim"
if HOME="$CONFLICT_HOME" "$REPO/dotfiles.sh" migrate >/dev/null 2>&1; then echo 'migration conflict was not rejected'; exit 1; fi
[ -L "$CONFLICT_HOME/.config/nvim" ]
[ "$(<"$REPO/.config/nvim/init.lua")" = 'local edit' ]

printf 'All dotfiles package tests passed.\n'
