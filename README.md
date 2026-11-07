# Dotfiles

<!--toc:start-->
- [Dotfiles](#dotfiles)
  - [What is GNU Stow?](#what-is-gnu-stow)
  - [Quick Start](#quick-start)
  - [Repository Structure](#repository-structure)
  - [Core Tools](#core-tools)
  - [Key Features](#key-features)
  - [Theming](#theming)
  - [Installation Requirements](#installation-requirements)
  - [Managing Configurations](#managing-configurations)
  - [Migrating the Existing Layout](#migrating-the-existing-layout)
    - [Mac transition](#mac-transition)
  - [Editing Configurations](#editing-configurations)
  - [Adding New Configurations](#adding-new-configurations)
  - [Customization](#customization)
  - [Useful Commands](#useful-commands)
  - [Notes](#notes)
  - [License](#license)
<!--toc:end-->

Personal dotfiles for Unix systems, managed with
[GNU Stow](https://www.gnu.org/software/stow/). Developed on macOS and compatible
with Linux and other Unix systems.

## What is GNU Stow?

GNU Stow creates symbolic links from repository packages into `$HOME`. Each tool
has a package so machines can activate only the configurations they use.
`dotfiles.sh` supplies the repository path and target.
When the app config target is absent, Stow links its directory as one unit,
so new files appear automatically. If the target exists, Stow preserves it
and links managed files or conflict-free subdirectories. Sesh stays file-linked
to keep the active `sesh.toml` local.

- Version control configurations without linking unrelated repository files
- Activate or remove individual tools independently
- Preview Stow changes and stop on conflicts
- Keep machine-local files, such as `~/.zshrc.local` and Sesh's active `sesh.toml`,
  outside package management

## Quick Start

```bash
# Clone the repository and install GNU Stow using your platform's package manager.
git clone https://github.com/franckdelage/dotfiles.git ~/dotfiles
cd ~/dotfiles

# See packages and platform compatibility, then preview selected tools.
./dotfiles.sh list
./dotfiles.sh stow --dry-run zsh nvim tmux

# Activate only the packages you want.
./dotfiles.sh stow zsh nvim tmux
```

The script works from any current directory. It never adopts or overwrites unrelated
files.

## Repository Structure

```text
dotfiles/
├── packages/
│   ├── zsh/                    # Zsh files, modules, and Oh-My-Zsh custom resources
│   ├── tmux/                   # Tmux config and helpers
│   ├── nvim/                   # Neovim config
│   ├── herdr/                  # Herdr config and plugin notes
│   ├── herdr-nvim/             # Herdr Neovim integration
│   ├── wezterm/                # .wezterm.lua and XDG theme files
│   ├── sesh/                   # Linux/macOS examples; active sesh.toml stays local
│   ├── macos-aerospace/        # macOS-only
│   ├── macos-karabiner/        # macOS-only config; backups are archived
│   ├── omarchy-hyprland/       # Omarchy-only personal overrides
│   ├── omarchy-shell/          # Omarchy-only shell.json override
│   └── …                       # One package per other tracked tool
├── packages/migration-map.tsv # Old-to-new source mapping and full tracked inventory
├── dotfiles.sh                # Package manager and legacy-link migration
├── install.sh                 # Optional interactive bootstrap
├── archive/                   # Backups and Screens-owned baselines; not deployed
├── tests/                     # Repository-only tests, including tmux/
└── keyboard/                  # Retained, not deployed
```

Agent metadata, archives, keyboard assets, tests, and repository tooling are not
deployed as dotfiles.

## Core Tools

### Shell & Terminal

- **Zsh** - Default shell with modular configuration
- **Starship** - Fast, customizable prompt (Catppuccin theme)
- **Tmux** - Terminal multiplexer with custom bindings
- **Wezterm** - GPU-accelerated terminal emulator

### Development Tools

- **Neovim** - Lua-based config with lazy.nvim, LSP, Treesitter
- **Git** - With delta for diffs
- **Node.js** - Via nvm with auto-switching
- **Python** - Via pyenv
- **Ruby** - Via rbenv

### Productivity Tools

- **fzf** - Fuzzy finder for files, history, processes
- **ripgrep** (rg) - Fast recursive grep
- **eza** - Modern ls replacement with icons
- **bat** - Cat with syntax highlighting
- **zoxide** - Smart cd replacement (learns from usage)
- **atuin** - Enhanced shell history with sync

### Window Management & macOS-Specific

- **Aerospace** - Tiling window manager (macOS only)
- **Karabiner Elements** - Advanced keyboard customization (macOS only)

## Key Features

### Modular Zsh Configuration

Configuration split into logical modules in `.zsh/`:

- Auto-loading of all `.zsh` files via `.zshrc`
- Plugin management with Oh-My-Zsh
- Smart completions and syntax highlighting
- Vi mode with enhanced keybindings
- FZF integration for fuzzy searching

### Neovim Setup

- **lazy.nvim** - Fast plugin manager
- **LSP** - Built-in language server support
- **Treesitter** - Advanced syntax highlighting
- **DAP** - Debug adapter protocol
- Modular configuration in `lua/` directory

### Tmux Configuration

Modular split for maintainability:

- `tmux.conf` - Sources other config files
- `appearance.conf` - Colors, status bar, theme
- `keybindings.conf` - All key mappings
- `plugins.conf` - TPM plugin configuration
- Mouse support, vim-style navigation

### Development Workflow

- **Auto version switching** - nvm, pyenv, rbenv with auto-load
  NVM loads on the first `nvm`, `node`, `npm`, `npx`, `corepack`, `yarn`, or `pnpm`
  command, or the first directory change. It then honors `.nvmrc` and automatically
  switches versions as directories change. A missing project version is installed
  when NVM loads or when entering that project, not during shell startup.
  Run `nvm use` first if another globally installed Node command is not on `PATH`.
  Python/Ruby initialization skips rehashing; run `pyenv rehash` or `rbenv rehash`
  after installing executables if their shims need refreshing.
  Homebrew's environment is initialized only once per shell.
- **Git integration** - Delta for diffs, custom aliases
- **gh-dash PR shortcuts** - `C` / `T` open code review / Actions in tmux;
  `Alt+c` / `Alt+t` do the same in a new Herdr tab (requires `herdr` and `jq`,
  with gh-dash running inside Herdr).
- **Unified theme** - Catppuccin across all tools
- **FZF everywhere** - File finding, history search, process management

## Theming

Consistent **Catppuccin** theme across tools:

- Starship prompt (Mocha variant)
- Bat syntax highlighting (Catppuccin Frappe/Latte/Macchiato/Mocha)
- Atuin history viewer
- Yazi file manager
- Terminal color schemes

## Installation Requirements

### All Unix Systems

- **GNU Stow** - Symlink manager
  - macOS: `brew install stow`
  - Debian/Ubuntu: `apt install stow`
  - Arch: `pacman -S stow`
  - Fedora: `dnf install stow`
- **Git** - Version control
- **Zsh** - Shell (optional, but recommended)

### macOS (Optional)

- **Homebrew** - Package manager, includes Brewfile for dependencies

## Managing Configurations

```bash
./dotfiles.sh list
./dotfiles.sh stow --dry-run nvim herdr
./dotfiles.sh stow nvim herdr
./dotfiles.sh unstow nvim herdr
./dotfiles.sh check
```

Pass package names explicitly; there is no automatic "all Linux" or "all macOS"
profile. Linux rejects `macos-*` packages. Omarchy packages require Omarchy Linux.
Stow preflights, then activates selected packages. It does not tear down and
recreate existing links. When an app target is absent, Stow links the directory
as one symlink. If it exists, Stow preserves it and links managed files or
conflict-free subdirectories. Sesh stays file-linked so the active
`~/.config/sesh/sesh.toml` remains local.

Screens owns active `bindings.lua` and `monitors.lua`; their baselines are
kept in `archive/omarchy-hyprland/` and are not deployed.

## Migrating the Existing Layout

`migrate` is separate from bootstrap. It does not install packages or plugins or
change the login shell. It finds old links from this repository, including relative
and dangling links. It reads `packages/migration-map.tsv`, infers active packages,
and simulates changes before applying them.

```bash
./dotfiles.sh migrate --dry-run
./dotfiles.sh migrate
./dotfiles.sh check
```

If a package is partly active, migration keeps only those paths and reports
missing files. It does not enable other files. Incompatible packages stay
untouched. It saves backups and a journal under
`~/.local/state/dotfiles/migrations/`.

### Mac transition

Full Mac steps and backup commands are in [`macos-dotfiles-migration.md`](macos-dotfiles-migration.md).

Before updating, keep a terminal open, preserve local changes, note the old Git
revision, and back up the repository and active configs. Old links may be briefly
dangling between the update and migration.

After updating, inspect `./dotfiles.sh migrate --dry-run`. Run `migrate` only
if its package selection matches the previously active configs. As a manual
alternative, back up first and remove only verified old symlinks. Use `rmdir`
only on empty directories. For each package, run
`./dotfiles.sh stow --dry-run PACKAGE`, inspect the proposed links, then
activate it with `./dotfiles.sh stow PACKAGE`. Manual Stow tries to activate
the whole package; unlike `migrate`, it does not preserve partial packages.
To get a whole-directory link, the target must be absent. Never delete real
config directories or local files blindly. Do not enable Omarchy packages
on macOS.

For rollback, run `./dotfiles.sh rollback <backup-directory>` while the new checkout
is present. Then restore the old revision so the old links resolve again.

## Editing Configurations

Since files are symlinked, edit them directly:

```bash
# These home paths resolve into packages in this repository.
vim ~/.zshrc
vim ~/.config/nvim/init.lua
vim ~/.tmux/tmux.conf
```

Changes are immediately tracked by git.

## Adding New Configurations

For an existing package, place each config file at the path it should have
under `$HOME`. For example, `~/.config/ghostty/config` belongs at
`packages/ghostty/.config/ghostty/config`. Add one row per managed file to
`packages/migration-map.tsv`: old home-relative path, package source path,
package name, and `managed` disposition. This lets `check` and `migrate`
recognize the link and old layout.

For a new tool, create `packages/<name>/` with the same home-relative layout
and add `<name>` to the `PACKAGES` array in `dotfiles.sh`. Use the `macos-` or
`omarchy-` prefix for platform-specific packages. Add every managed file to
the migration map as described above.

Preview and activate the package:

```bash
./dotfiles.sh stow --dry-run <name>
./dotfiles.sh stow <name>
```

If an old link or local file occupies a target path, back it up and inspect it
first. Stow preflights changes and does not adopt or overwrite unrelated files.

## Customization

### Zsh

- **Add aliases**: Edit `.zsh/aliases.zsh`
- **Add functions**: Create new files in `.zsh/`
- **Environment variables**: Edit the relevant `.zsh/env-*.zsh` module
- **Local overrides**: Use `.zshrc.local` (not tracked)

### Tmux

- **Appearance**: Edit `.tmux/appearance.conf`
- **Keybindings**: Edit `.tmux/keybindings.conf`
- **Plugins**: Edit `.tmux/plugins.conf`

### Neovim

- **Plugins**: Add to `.config/nvim/lua/plugins/`
- **LSP servers**: Configure in `.config/nvim/lua/lsp/`
- **Keymaps**: Edit `.config/nvim/lua/keymaps.lua`

## Useful Commands

```bash
# Reload zsh
source ~/.zshrc

# Reload tmux config
tmux source ~/.tmux/tmux.conf

# Preview selected packages
./dotfiles.sh stow --dry-run nvim

# Update macOS packages
brew bundle --file=~/dotfiles/Brewfile

# Linux package updates are distribution-specific.
sudo apt update && sudo apt upgrade

# Search history with fzf
# Press Ctrl+R

# Smart directory navigation
z <partial-name>    # Uses zoxide
```

## Notes

- **Cross-platform**: shared tool packages plus explicit OS-specific packages
- **macOS-only**: Aerospace and Karabiner
- **Omarchy-only**: personal Hyprland and shell overrides; no system defaults are
  copied
- **Local settings**: use `.zshrc.local` and the local Sesh `sesh.toml` for
  machine-specific state
- **Safe removal**: use `./dotfiles.sh unstow PACKAGE...` after reviewing the package
  selection

## License

Personal dotfiles - feel free to use as reference or starting point.

---

*Terminal-centric development environment managed with GNU Stow for clean,
reversible configuration management.*
