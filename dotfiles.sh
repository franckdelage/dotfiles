#!/usr/bin/env bash
# Manage independent GNU Stow packages and migrate links from the pre-packages layout.
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
PACKAGE_DIR="$SCRIPT_DIR/packages"
MAP_FILE="$PACKAGE_DIR/migration-map.tsv"
TARGET_HOME="${HOME:?HOME must be set}"
PACKAGES=(atuin bat gh-dash ghostty herdr herdr-nvim lazygit macos-aerospace macos-karabiner markdownlint nvim omarchy-hyprland omarchy-shell opencode ranger sesh starship tmux wezterm yazi zsh)

fail() { printf 'dotfiles: %s\n' "$*" >&2; exit 1; }
contains() {
  local wanted="$1"
  shift
  local value
  for value in "$@"; do [ "$value" = "$wanted" ] && return 0; done
  return 1
}

platform() {
  case "$(uname -s)" in
    Darwin*) printf 'macos\n' ;;
    Linux*) printf 'linux\n' ;;
    *) printf 'unsupported\n' ;;
  esac
}
is_omarchy() {
  if [ "${OMARCHY_PATH+x}" = x ]; then
    [ -n "$OMARCHY_PATH" ] && [ -d "$OMARCHY_PATH" ]
  else
    [ -d /usr/share/omarchy ] && command -v omarchy >/dev/null 2>&1
  fi
}
package_compatibility() {
  case "$1" in
    macos-*) [ "$(platform)" = macos ] && printf 'macOS only' || printf 'macOS only (incompatible here)' ;;
    omarchy-*) is_omarchy && printf 'Omarchy Linux only' || printf 'Omarchy Linux only (incompatible here)' ;;
    *) printf 'Linux + macOS' ;;
  esac
}
package_is_compatible() {
  case "$1" in
    macos-*) [ "$(platform)" = macos ] ;;
    omarchy-*) [ "$(platform)" = linux ] && is_omarchy ;;
    *) [ "$(platform)" = linux ] || [ "$(platform)" = macos ] ;;
  esac
}
validate_package_names() {
  [ "$#" -gt 0 ] || fail 'name at least one package'
  local package
  for package in "$@"; do
    contains "$package" "${PACKAGES[@]}" || fail "unknown package: $package (run ./dotfiles.sh list)"
    [ -d "$PACKAGE_DIR/$package" ] || fail "package directory is missing: $PACKAGE_DIR/$package"
    package_is_compatible "$package" || fail "package '$package' is incompatible with $(platform); compatibility: $(package_compatibility "$package")"
  done
}
stow_package() {
  local mode="$1" target="$2" package="$3"
  local -a args
  args=("--dir=$PACKAGE_DIR" "--target=$target")
  if [ "$package" = sesh ]; then args+=(--no-folding); fi
  case "$mode" in
    simulate-stow) args+=(--simulate --verbose=1) ;;
    stow) ;;
    simulate-delete) args+=(--simulate --verbose=1 --delete) ;;
    delete) args+=(--delete) ;;
    *) fail "internal error: invalid Stow mode $mode" ;;
  esac
  stow "${args[@]}" "$package"
}
stow_command() {
  local mode="$1" package
  shift
  for package in "$@"; do
    stow_package "$mode" "$TARGET_HOME" "$package" || return 1
  done
}

list_packages() {
  local package
  printf '%-22s %s\n' PACKAGE COMPATIBILITY
  printf '%-22s %s\n' '----------------------' '--------------------------'
  for package in "${PACKAGES[@]}"; do
    printf '%-22s %s\n' "$package" "$(package_compatibility "$package")"
  done
}

run_stow() {
  local action="$1" dry_run="$2"
  shift 2
  validate_package_names "$@"
  if [ "$action" = stow ]; then
    if stow_command simulate-stow "$@"; then :; else fail 'Stow simulation found a conflict; no changes made'; fi
    [ "$dry_run" = yes ] && return 0
    stow_command stow "$@" || fail 'Stow activation failed'
  else
    if stow_command simulate-delete "$@"; then :; else fail 'Stow removal simulation failed; no changes made'; fi
    stow_command delete "$@" || fail 'Stow removal failed'
  fi
}

normalize_path() {
  local input="$1" part result=/
  local -a parts
  IFS='/' read -r -a parts <<< "$input"
  for part in "${parts[@]}"; do
    case "$part" in
      ''|.) ;;
      ..) result="${result%/}"; result="${result%/*}/"; [ "$result" = '//' ] && result=/ ;;
      *) result="${result%/}/$part" ;;
    esac
  done
  [ -n "$result" ] || result=/
  printf '%s\n' "$result"
}

same_link_target() {
  local link="$1" expected="$2" raw actual parent
  raw="$(readlink "$link")" || return 1
  if [[ "$raw" = /* ]]; then
    actual="$(normalize_path "$raw")"
  else
    parent="$(cd "$(dirname "$link")" 2>/dev/null && pwd -P)" || return 1
    actual="$(normalize_path "$parent/$raw")"
  fi
  [ "$actual" = "$(normalize_path "$expected")" ]
}

relative_path() {
  local from="$1" to="$2" index=0 common=0 result=''
  local -a from_parts to_parts
  IFS='/' read -r -a from_parts <<< "$(normalize_path "$from")"
  IFS='/' read -r -a to_parts <<< "$(normalize_path "$to")"
  while [ "$index" -lt "${#from_parts[@]}" ] && [ "$index" -lt "${#to_parts[@]}" ] && [ "${from_parts[$index]}" = "${to_parts[$index]}" ]; do
    index=$((index + 1))
  done
  common="$index"
  while [ "$index" -lt "${#from_parts[@]}" ]; do
    [ -z "${from_parts[$index]}" ] || result="${result}../"
    index=$((index + 1))
  done
  index="$common"
  while [ "$index" -lt "${#to_parts[@]}" ]; do
    if [ -n "${to_parts[$index]}" ]; then
      [ -z "$result" ] || result="${result%/}/"
      result="${result}${to_parts[$index]}"
    fi
    index=$((index + 1))
  done
  [ -n "$result" ] || result=.
  printf '%s\n' "$result"
}

legacy_roots() {
  printf '%s\n' "$SCRIPT_DIR"
  [ "$TARGET_HOME/dotfiles" = "$SCRIPT_DIR" ] || printf '%s\n' "$(normalize_path "$TARGET_HOME/dotfiles")"
}

path_prefix_for() {
  local old="$1" rest first
  case "$old" in
    .config/*)
      rest="${old#.config/}"
      case "$rest" in */*) first="${rest%%/*}"; printf '.config/%s\n' "$first" ;; *) printf '%s\n' "$old" ;; esac
      ;;
    */*) printf '%s\n' "${old%%/*}" ;;
    *) printf '%s\n' "$old" ;;
  esac
}

# Remove only empty directories corresponding to managed paths in this package.
prune_package_target_directories() {
  local home="$1" wanted="$2" old new package disposition root directory
  while IFS="$(printf '\t')" read -r old new package disposition; do
    [ "$package" = "$wanted" ] && [ "$disposition" = managed ] || continue
    root="$home/$(path_prefix_for "$old")"
    directory="$home/$(dirname "$old")"
    while :; do
      case "$directory" in "$root"|"$root"/*) ;; *) break ;; esac
      [ -d "$directory" ] && [ ! -L "$directory" ] || break
      rmdir "$directory" 2>/dev/null || break
      [ "$directory" = "$root" ] && break
      directory="$(dirname "$directory")"
    done
  done < "$MAP_FILE"
  return 0
}
target_candidates() {
  local destination="$1" old new package disposition path
  : > "$destination"
  while IFS="$(printf '\t')" read -r old new package disposition; do
    contains "$package" "${PACKAGES[@]}" || continue
    path="$old"
    while [ -n "$path" ]; do
      printf '%s\n' "$path" >> "$destination"
      case "$path" in */*) path="${path%/*}" ;; *) path='' ;; esac
    done
  done < "$MAP_FILE"
  sort -u "$destination" -o "$destination"
}

has_symlink_parent() {
  local candidate="$1" parent='' index
  local -a parts
  IFS='/' read -r -a parts <<< "$candidate"
  index=0
  while [ "$index" -lt "$((${#parts[@]} - 1))" ]; do
    [ -n "${parts[$index]}" ] || { index=$((index + 1)); continue; }
    if [ -n "$parent" ]; then parent="$parent/${parts[$index]}"; else parent="${parts[$index]}"; fi
    [ -L "$TARGET_HOME/$parent" ] && return 0
    index=$((index + 1))
  done
  return 1
}

# Inspect only paths Stow could have created; do not recurse through the whole HOME.
discover_legacy_links() {
  local out="$1" links="$2" roots="$3" candidates candidate link raw parent resolved root old_rel old new package disposition
  : > "$out"
  : > "$links"
  legacy_roots > "$roots"
  candidates="$links.candidates"
  target_candidates "$candidates"
  printf 'Scanning %s known Stow target paths for legacy links.\n' "$(wc -l < "$candidates" | tr -d ' ')"
  while IFS= read -r candidate; do
    link="$TARGET_HOME/$candidate"
    [ -L "$link" ] || continue
    has_symlink_parent "$candidate" && continue
    raw="$(readlink "$link")" || continue
    if [[ "$raw" = /* ]]; then
      resolved="$(normalize_path "$raw")"
    else
      parent="$(cd "$(dirname "$link")" 2>/dev/null && pwd -P)" || continue
      resolved="$(normalize_path "$parent/$raw")"
    fi
    while IFS= read -r root; do
      case "$resolved" in
        "$root"/*) old_rel="${resolved#"$root"/}" ;;
        *) continue ;;
      esac
      while IFS="$(printf '\t')" read -r old new package disposition; do
        [ "$package" != - ] || continue
        [ "$disposition" = managed ] || continue
        case "$old" in
          "$old_rel"|"$old_rel"/*)
            printf '%s\t%s\t%s\t%s\t%s\n' "$link" "$raw" "$resolved" "$old_rel" "$package" >> "$out"
            printf '%s\n' "$link" >> "$links"
            ;;
        esac
      done < "$MAP_FILE"
    done < "$roots"
  done < "$candidates"
  rm -f "$candidates"
  sort -u "$links" -o "$links"
}

is_link_compatible() {
  local link="$1" row_link package any_compatible=no any_incompatible=no
  while IFS="$(printf '\t')" read -r row_link raw resolved old_rel package; do
    [ "$row_link" = "$link" ] || continue
    if package_is_compatible "$package"; then any_compatible=yes; else any_incompatible=yes; fi
  done < "$1.discovered"
  [ "$any_compatible" = yes ] && [ "$any_incompatible" = no ]
}

# Build unique selected links, compatible package sets, and the set of active files.
prepare_migration_selection() {
  local discovered="$1" links="$2" active_links="$3" packages_file="$4" active_file="$5" partial_file="$6"
  local link raw resolved old_rel package old new disposition row_link found selected expected active missing
  : > "$active_links"; : > "$packages_file"; : > "$active_file"; : > "$partial_file"
  cp "$discovered" "$active_links.discovered"
  while IFS= read -r link; do
    [ -n "$link" ] || continue
    local compatible=yes incompatible=no
    while IFS="$(printf '\t')" read -r row_link raw resolved old_rel package; do
      [ "$row_link" = "$link" ] || continue
      if package_is_compatible "$package"; then :; else incompatible=yes; fi
    done < "$discovered"
    if [ "$incompatible" = yes ]; then
      local has_compatible=no
      while IFS="$(printf '\t')" read -r row_link raw resolved old_rel package; do
        [ "$row_link" = "$link" ] || continue
        package_is_compatible "$package" && has_compatible=yes
      done < "$discovered"
      if [ "$has_compatible" = yes ]; then
        printf 'dotfiles: legacy link spans compatible and incompatible packages; refusing to split it: %s\n' "$link" >&2
        return 1
      fi
      printf 'Leaving incompatible legacy link untouched: %s\n' "$link"
      continue
    fi
    printf '%s\n' "$link" >> "$active_links"
  done < "$links"

  while IFS="$(printf '\t')" read -r link raw resolved old_rel package; do
    grep -Fqx "$link" "$active_links" || continue
    grep -Fqx "$package" "$packages_file" || printf '%s\n' "$package" >> "$packages_file"
  done < "$discovered"

  while IFS="$(printf '\t')" read -r old new package disposition; do
    [ "$disposition" = managed ] || continue
    grep -Fqx "$package" "$packages_file" || continue
    active=no
    while IFS="$(printf '\t')" read -r link raw resolved old_rel row_package; do
      [ "$row_package" = "$package" ] || continue
      grep -Fqx "$link" "$active_links" || continue
      case "$old" in "$old_rel"|"$old_rel"/*) active=yes ;; esac
    done < "$discovered"
    [ "$active" = yes ] && printf '%s\t%s\t%s\n' "$package" "$old" "$new" >> "$active_file"
  done < "$MAP_FILE"

  while IFS= read -r package; do
    [ -n "$package" ] || continue
    expected=0; active=0; missing=''
    while IFS="$(printf '\t')" read -r old new row_package disposition; do
      [ "$row_package" = "$package" ] && [ "$disposition" = managed ] || continue
      expected=$((expected + 1))
      if grep -Fq "$(printf '%s\t%s\t' "$package" "$old")" "$active_file"; then
        active=$((active + 1))
      else
        missing="$missing $old"
      fi
    done < "$MAP_FILE"
    if [ "$active" -lt "$expected" ]; then
      printf '%s\t%s\n' "$package" "$missing" >> "$partial_file"
    fi
  done < "$packages_file"
}

copy_existing_prefixes() {
  local root="$1" packages_file="$2" active_file="$3" prefix old new package disposition
  local prefixes="$4"
  : > "$prefixes"
  while IFS="$(printf '\t')" read -r old new package disposition; do
    [ "$disposition" = managed ] || continue
    grep -Fqx "$package" "$packages_file" || continue
    prefix="$(path_prefix_for "$old")"
    grep -Fqx "$prefix" "$prefixes" || printf '%s\n' "$prefix" >> "$prefixes"
  done < "$MAP_FILE"
  while IFS= read -r prefix; do
    [ -n "$prefix" ] || continue
    if [ -e "$TARGET_HOME/$prefix" ] || [ -L "$TARGET_HOME/$prefix" ]; then
      mkdir -p "$root/$(dirname "$prefix")"
      cp -a "$TARGET_HOME/$prefix" "$root/$prefix"
    fi
  done < "$prefixes"
}

materialize_old_directories() {
  local root="$1" active_links="$2" discovered="$3" old new package disposition
  local link raw resolved old_rel row_link row_package remainder local_copy source_copy
  while IFS= read -r link; do
    [ -n "$link" ] || continue
    local source_rel=''
    while IFS="$(printf '\t')" read -r row_link raw resolved old_rel row_package; do
      [ "$row_link" = "$link" ] || continue
      source_rel="$old_rel"
      break
    done < "$discovered"
    [ -n "$source_rel" ] || continue
    local has_children=no
    while IFS="$(printf '\t')" read -r old new package disposition; do
      case "$old" in "$source_rel"/*) has_children=yes; break ;; esac
    done < "$MAP_FILE"
    [ "$has_children" = yes ] || continue
    local source_abs=''
    while IFS="$(printf '\t')" read -r row_link raw resolved old_rel row_package; do
      [ "$row_link" = "$link" ] || continue
      source_abs="$resolved"
      break
    done < "$discovered"
    [ -d "$source_abs" ] || continue
    local relative_link="${link#"$TARGET_HOME"/}"
    [ "$relative_link" != "$link" ] || continue
    if [ -L "$root/$relative_link" ]; then rm "$root/$relative_link"; fi
    mkdir -p "$root/$relative_link"
    cp -a "$source_abs/." "$root/$relative_link/"
    # Remove only byte-identical copies of managed files; changed files remain and
    # make the subsequent Stow simulation fail as a local conflict.
    while IFS="$(printf '\t')" read -r old new package disposition; do
      [ "$disposition" = managed ] || continue
      case "$old" in
        "$source_rel"/*)
          remainder="${old#"$source_rel"/}"
          local_copy="$root/$relative_link/$remainder"
          source_copy="$SCRIPT_DIR/$new"
          if [ -f "$local_copy" ] && [ -f "$source_copy" ] && cmp -s "$local_copy" "$source_copy"; then rm -f "$local_copy"; fi
          ;;
      esac
    done < "$MAP_FILE"
  done < "$active_links"
}

remove_legacy_links() {
  local root="$1" active_links="$2" link relative
  while IFS= read -r link; do
    [ -n "$link" ] || continue
    relative="${link#"$TARGET_HOME"/}"
    [ "$relative" != "$link" ] || continue
    [ -L "$root/$relative" ] && rm "$root/$relative"
  done < "$active_links"
  return 0
}

link_partial_files() {
  local root="$1" active_file="$2" package old new target source parent relative
  while IFS="$(printf '\t')" read -r package old new; do
    grep -Fq "$(printf '%s\t' "$package")" "$2.partial" 2>/dev/null || continue
    target="$root/$old"
    source="$SCRIPT_DIR/$new"
    [ -e "$source" ] || fail "new package source is missing: $source"
    if [ -e "$target" ] || [ -L "$target" ]; then
      if [ -L "$target" ] && same_link_target "$target" "$source"; then
        if [[ "$(readlink "$target")" = /* ]]; then
          parent="$(cd "$(dirname "$target")" && pwd -P)"
          relative="$(relative_path "$parent" "$source")"
          rm "$target"
          ln -s "$relative" "$target"
        fi
        continue
      fi
      fail "partial package target is occupied: $target"
    fi
    mkdir -p "$(dirname "$target")"
    parent="$(cd "$(dirname "$target")" && pwd -P)"
    ln -s "$(relative_path "$parent" "$source")" "$target"
  done < "$active_file"
}

same_effective_target() {
  local target="$1" expected="$2" parent actual
  if [ -L "$target" ]; then same_link_target "$target" "$expected" && return 0; fi
  [ -e "$target" ] || return 1
  parent="$(cd "$(dirname "$target")" 2>/dev/null && pwd -P)" || return 1
  actual="$(normalize_path "$parent/$(basename "$target")")"
  [ "$actual" = "$(normalize_path "$expected")" ]
}
verify_migration_links() {
  local active_file="$1" package old new target source
  while IFS="$(printf '\t')" read -r package old new; do
    target="$TARGET_HOME/$old"; source="$SCRIPT_DIR/$new"
    if ! same_effective_target "$target" "$source"; then
      printf 'Migration verification failed: %s is not linked to %s\n' "$target" "$source" >&2
      return 1
    fi
  done < "$active_file"
}

migrate() {
  local dry_run=no
  if [ "${1:-}" = --dry-run ]; then dry_run=yes; shift; fi
  [ "$#" -eq 0 ] || fail 'usage: ./dotfiles.sh migrate [--dry-run]'
  command -v stow >/dev/null 2>&1 || fail 'GNU Stow is required'
  [ -f "$MAP_FILE" ] || fail "migration map is missing: $MAP_FILE"
  local work discovered links active_links packages_file active_file partial_file prefixes sandbox
  work="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-migrate.XXXXXX")" || fail 'cannot create temporary migration directory'
  discovered="$work/discovered.tsv"; links="$work/links.txt"; active_links="$work/active-links.txt"
  packages_file="$work/packages.txt"; active_file="$work/active-files.tsv"; partial_file="$work/partial.tsv"
  discover_legacy_links "$discovered" "$links" "$work/roots.txt"
  if [ ! -s "$discovered" ]; then
    printf 'No links to the legacy dotfiles layout were found.\n'
    rm -rf "$work"
    return 0
  fi
  prepare_migration_selection "$discovered" "$links" "$active_links" "$packages_file" "$active_file" "$partial_file" || fail 'cannot safely split legacy links'
  if [ ! -s "$packages_file" ]; then
    printf 'No compatible legacy links need migration. Incompatible links were left untouched.\n'
    rm -rf "$work"
    return 0
  fi
  printf 'Packages inferred from legacy links:\n'
  while IFS= read -r package; do
    printf '  %s (%s)\n' "$package" "$(package_compatibility "$package")"
  done < "$packages_file"
  if [ -s "$partial_file" ]; then
    printf 'Partial packages will keep only already-active files; missing paths will not be enabled:\n'
    while IFS="$(printf '\t')" read -r package missing; do printf '  %s:%s\n' "$package" "$missing"; done < "$partial_file"
  fi
  printf 'Recognized legacy links: %s\n' "$(wc -l < "$active_links" | tr -d ' ')"
  [ "$dry_run" = no ] || printf 'Dry run: no files or links were changed.\n'

  sandbox="$work/home"
  mkdir -p "$sandbox"
  copy_existing_prefixes "$sandbox" "$packages_file" "$active_file" "$work/prefixes.txt"
  materialize_old_directories "$sandbox" "$active_links" "$discovered"
  remove_legacy_links "$sandbox" "$active_links"
  local -a complete_packages
  complete_packages=()
  while IFS= read -r package; do
    [ -n "$package" ] || continue
    if ! grep -Fq "$(printf '%s\t' "$package")" "$partial_file" 2>/dev/null; then complete_packages+=("$package"); fi
  done < "$packages_file"
  if [ "${#complete_packages[@]}" -gt 0 ]; then
    for package in "${complete_packages[@]}"; do
      if [ "$package" != sesh ]; then prune_package_target_directories "$sandbox" "$package"; fi
      stow_package simulate-stow "$sandbox" "$package" || fail 'migration simulation found a conflict; no active links changed'
    done
  fi
  cp "$partial_file" "$active_file.partial"
  link_partial_files "$sandbox" "$active_file"
  [ "$dry_run" = no ] || { rm -rf "$work"; return 0; }

  local stamp backup prefix link raw resolved old_rel row_package
  stamp="$(date +%Y%m%d-%H%M%S)"
  backup="$TARGET_HOME/.local/state/dotfiles/migrations/$stamp-$$"
  mkdir -p "$backup/targets" "$backup/legacy-sources"
  cp "$active_links" "$backup/legacy-links.txt"
  cp "$packages_file" "$backup/packages.txt"
  cp "$active_file" "$backup/active-files.tsv"
  cp "$partial_file" "$backup/partial.tsv"
  cp "$work/prefixes.txt" "$backup/targets.txt"
  cp "$discovered" "$backup/links.tsv"
  printf 'Created: %s\n' "$(date)" > "$backup/migration.log"
  printf 'Repository: %s\nHome: %s\n' "$SCRIPT_DIR" "$TARGET_HOME" >> "$backup/migration.log"
  while IFS= read -r prefix; do
    [ -n "$prefix" ] || continue
    if [ -e "$TARGET_HOME/$prefix" ] || [ -L "$TARGET_HOME/$prefix" ]; then
      mkdir -p "$backup/targets/$(dirname "$prefix")"
      cp -a "$TARGET_HOME/$prefix" "$backup/targets/$prefix"
    fi
  done < "$work/prefixes.txt"
  while IFS="$(printf '\t')" read -r link raw resolved old_rel row_package; do
    [ -d "$resolved" ] || continue
    mkdir -p "$backup/legacy-sources/$(dirname "$old_rel")"
    [ -e "$backup/legacy-sources/$old_rel" ] || cp -a "$resolved" "$backup/legacy-sources/$old_rel"
  done < "$discovered"
  printf 'Migration backup prepared at %s\n' "$backup"

  # Apply the exact preflighted transition.
  materialize_old_directories "$TARGET_HOME" "$active_links" "$discovered"
  remove_legacy_links "$TARGET_HOME" "$active_links"
  if [ "${#complete_packages[@]}" -gt 0 ]; then
    for package in "${complete_packages[@]}"; do
      if [ "$package" != sesh ]; then prune_package_target_directories "$TARGET_HOME" "$package"; fi
      if ! stow_package stow "$TARGET_HOME" "$package"; then
        printf 'Migration activation failed. Backup retained at %s\n' "$backup" >&2
        fail 'new links may be partial; use check and the backup journal to recover'
      fi
    done
  fi
  cp "$partial_file" "$active_file.partial"
  if ! link_partial_files "$TARGET_HOME" "$active_file"; then
    printf 'Migration activation failed. Backup retained at %s\n' "$backup" >&2
    fail 'new links may be partial; use check and the backup journal to recover'
  fi
  if ! verify_migration_links "$active_file"; then
    printf 'Migration backup retained at %s\n' "$backup" >&2
    fail 'migration link verification failed; use the backup journal to recover'
  fi
  printf 'Migration complete. Verify links with ./dotfiles.sh check\nBackup: %s\n' "$backup"
  rm -rf "$work"
}

check_packages() {
  command -v stow >/dev/null 2>&1 || fail 'GNU Stow is required'
  local work active candidates candidate link raw parent resolved package failures=0
  work="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-check.XXXXXX")" || fail 'cannot create temporary check directory'
  active="$work/active-packages.txt"
  candidates="$work/target-candidates.txt"
  : > "$active"
  target_candidates "$candidates"

  while IFS= read -r candidate; do
    link="$TARGET_HOME/$candidate"
    [ -L "$link" ] || continue
    has_symlink_parent "$candidate" && continue
    raw="$(readlink "$link")" || continue
    if [[ "$raw" = /* ]]; then
      resolved="$(normalize_path "$raw")"
    else
      parent="$(cd "$(dirname "$link")" 2>/dev/null && pwd -P)" || continue
      resolved="$(normalize_path "$parent/$raw")"
    fi
    for package in "${PACKAGES[@]}"; do
      case "$resolved" in
        "$PACKAGE_DIR/$package"|"$PACKAGE_DIR/$package"/*)
          if [ -e "$resolved" ]; then
            grep -Fqx "$package" "$active" || printf '%s\n' "$package" >> "$active"
          else
            printf 'BROKEN  %s -> %s\n' "$link" "$resolved"
            failures=$((failures + 1))
          fi
          break
          ;;
      esac
    done
  done < "$candidates"

  if [ ! -s "$active" ]; then
    printf 'No links into Stow packages were found.\n'
    rm -rf "$work"
    [ "$failures" -eq 0 ] || fail "$failures broken package link(s)"
    return 0
  fi
  while IFS= read -r package; do
    [ -n "$package" ] || continue
    if ! package_is_compatible "$package"; then
      printf 'SKIP    %s (%s)\n' "$package" "$(package_compatibility "$package")"
      continue
    fi
    if stow_command simulate-stow "$package" >/dev/null; then
      printf 'OK      %s\n' "$package"
    else
      printf 'CONFLICT %s\n' "$package"
      failures=$((failures + 1))
    fi
  done < "$active"
  rm -rf "$work"
  [ "$failures" -eq 0 ] || fail "$failures active package check(s) failed"
}

remove_empty_directories() {
  local directory="$1" child
  [ -d "$directory" ] && [ ! -L "$directory" ] || return 0
  for child in "$directory"/* "$directory"/.[!.]* "$directory"/..?*; do
    [ -e "$child" ] || [ -L "$child" ] || continue
    [ -d "$child" ] && [ ! -L "$child" ] && remove_empty_directories "$child"
  done
  rmdir "$directory" 2>/dev/null || true
}
rollback() {
  local backup="${1:-}"
  [ -n "$backup" ] && [ "$#" -eq 1 ] || fail 'usage: ./dotfiles.sh rollback <backup-directory>'
  [ -d "$backup" ] || fail "backup directory not found: $backup"
  [ -f "$backup/packages.txt" ] && [ -f "$backup/active-files.tsv" ] || fail 'backup journal is incomplete'
  local -a packages
  packages=()
  while IFS= read -r package; do [ -n "$package" ] && packages+=("$package"); done < "$backup/packages.txt"
  if [ "${#packages[@]}" -gt 0 ]; then
    stow_command delete "${packages[@]}" || fail 'could not remove migrated Stow links'
  fi
  local old new row_package target source prefix
  while IFS="$(printf '\t')" read -r row_package old new; do
    grep -Fq "$(printf '%s\t' "$row_package")" "$backup/partial.tsv" || continue
    target="$TARGET_HOME/$old"; source="$SCRIPT_DIR/$new"
    if [ -L "$target" ] && same_link_target "$target" "$source"; then rm "$target"; fi
  done < "$backup/active-files.tsv"
  # Restore only saved paths that are now absent. Never replace a file created
  # after migration; the user can preserve it and resolve the conflict manually.
  while IFS= read -r prefix; do
    [ -n "$prefix" ] || continue
    [ -e "$backup/targets/$prefix" ] || [ -L "$backup/targets/$prefix" ] || continue
    if [ -e "$TARGET_HOME/$prefix" ] || [ -L "$TARGET_HOME/$prefix" ]; then
      if [ -d "$TARGET_HOME/$prefix" ] && [ ! -L "$TARGET_HOME/$prefix" ]; then
        if [ -L "$backup/targets/$prefix" ]; then remove_empty_directories "$TARGET_HOME/$prefix"; fi
        [ ! -e "$TARGET_HOME/$prefix" ] && [ ! -L "$TARGET_HOME/$prefix" ] || rmdir "$TARGET_HOME/$prefix" 2>/dev/null || fail "rollback target is not empty; preserved at $TARGET_HOME/$prefix"
      else
        fail "rollback target already exists; preserved: $TARGET_HOME/$prefix"
      fi
    fi
    mkdir -p "$TARGET_HOME/$(dirname "$prefix")"
    cp -a "$backup/targets/$prefix" "$TARGET_HOME/$prefix"
  done < "$backup/targets.txt"
  printf 'Restored saved legacy links from %s\n' "$backup"
  printf 'If legacy source files moved in Git, restore the previous repository revision first.\n'
}

usage() {
  cat <<'EOF'
Usage:
  ./dotfiles.sh list
  ./dotfiles.sh migrate [--dry-run]
  ./dotfiles.sh stow [--dry-run] PACKAGE...
  ./dotfiles.sh unstow PACKAGE...
  ./dotfiles.sh check
  ./dotfiles.sh rollback BACKUP_DIRECTORY

Stow operations use this repository as the source and $HOME as the target.
No package profile is selected automatically.
EOF
}

main() {
  [ -d "$PACKAGE_DIR" ] || fail "packages directory not found: $PACKAGE_DIR"
  local command="${1:-}"
  [ "$#" -gt 0 ] && shift || true
  case "$command" in
    list) [ "$#" -eq 0 ] || fail 'usage: ./dotfiles.sh list'; list_packages ;;
    stow)
      local dry_run=no
      if [ "${1:-}" = --dry-run ]; then dry_run=yes; shift; fi
      command -v stow >/dev/null 2>&1 || fail 'GNU Stow is required'
      run_stow stow "$dry_run" "$@"
      ;;
    unstow)
      command -v stow >/dev/null 2>&1 || fail 'GNU Stow is required'
      run_stow unstow no "$@"
      ;;
    migrate) migrate "$@" ;;
    check) [ "$#" -eq 0 ] || fail 'usage: ./dotfiles.sh check'; check_packages ;;
    rollback) rollback "$@" ;;
    -h|--help|help|'') usage ;;
    *) usage >&2; fail "unknown command: $command" ;;
  esac
}
main "$@"
