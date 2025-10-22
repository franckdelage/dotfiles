# Dotfiles

<!--toc:start-->
- [Dotfiles](#dotfiles)
  - [What is GNU Stow?](#what-is-gnu-stow)
  - [Quick Start](#quick-start)
  - [Repository Structure](#repository-structure)
  - [Core Tools](#core-tools)
    - [Shell & Terminal](#shell-terminal)
    - [Development Tools](#development-tools)
    - [Productivity Tools](#productivity-tools)
    - [Window Management & macOS-Specific](#window-management-macos-specific)
  - [Key Features](#key-features)
    - [Modular Zsh Configuration](#modular-zsh-configuration)
    - [Neovim Setup](#neovim-setup)
    - [Tmux Configuration](#tmux-configuration)
    - [Development Workflow](#development-workflow)
  - [Theming](#theming)
  - [Installation Requirements](#installation-requirements)
    - [All Unix Systems](#all-unix-systems)
    - [macOS (Optional)](#macos-optional)
  - [Managing Configurations](#managing-configurations)
    - [Install All Configurations](#install-all-configurations)
    - [Remove All Symlinks](#remove-all-symlinks)
    - [Dry Run (Preview Changes)](#dry-run-preview-changes)
    - [Restow (Update Symlinks)](#restow-update-symlinks)
    - [Conflicts](#conflicts)
  - [Editing Configurations](#editing-configurations)
  - [Adding New Configurations](#adding-new-configurations)
  - [Customization](#customization)
    - [Zsh](#zsh)
    - [Tmux](#tmux)
    - [Neovim](#neovim)
  - [Useful Commands](#useful-commands)
  - [Notes](#notes)
  - [License](#license)
<!--toc:end-->

Personal dotfiles for Unix-based systems, organized for [GNU Stow](https://www.gnu.org/software/stow/) symlink management. Developed on macOS but compatible with Linux and other Unix systems.

## What is GNU Stow?

GNU Stow creates symbolic links from this repository to your home directory. When you run `stow .` from this directory, it symlinks all files and directories to `~/`, maintaining the same structure. This allows you to:

- Version control all configs in one place
- Apply/remove configs atomically
- Edit files directly (changes sync via symlinks)
- Maintain clean separation between different tool configs

## Quick Start

```bash
# Clone the repository
git clone https://github.com/franckdelage/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install dependencies
# macOS (Homebrew)
brew bundle --file=Brewfile

# Linux (example with apt)
sudo apt install zsh tmux neovim git fzf ripgrep bat eza zoxide stow

# Backup existing configs (recommended)
mv ~/.zshrc ~/.zshrc.backup 2>/dev/null
mv ~/.config ~/.config.backup 2>/dev/null

# Create symlinks with GNU Stow
stow .
```

After stowing, all dotfiles are symlinked:
- `~/dotfiles/.zshrc` → `~/.zshrc`
- `~/dotfiles/.config/nvim/` → `~/.config/nvim/`
- `~/dotfiles/.tmux/` → `~/.tmux/`
- etc.

## Repository Structure

```
dotfiles/
├── .config/              # XDG config directory
│   ├── nvim/             # Neovim configuration (Lua-based, lazy.nvim)
│   ├── aerospace/        # Aerospace window manager config
│   ├── yazi/             # Yazi file manager config
│   ├── atuin/            # Atuin shell history config
│   ├── bat/              # Bat (cat replacement) themes
│   ├── karabiner/        # Karabiner Elements keyboard config
│   ├── wezterm/          # Wezterm terminal themes
│   ├── markdownlint/     # Markdown linting config
│   ├── opencode/         # OpenCode config
│   ├── ranger/           # Ranger file manager config
│   ├── sesh/             # Sesh session manager config
│   └── starship.toml     # Starship prompt configuration
│
├── .tmux/                # Tmux configuration (modular split)
│   ├── tmux.conf         # Main config
│   ├── appearance.conf   # Colors & status bar
│   ├── keybindings.conf  # Key mappings
│   ├── plugins.conf      # Plugin configuration
│   └── *.sh              # Helper scripts
│
├── .zsh/                 # Zsh configuration modules
│   ├── aliases.zsh       # Command aliases
│   ├── completion.zsh    # Completion settings
│   ├── env.zsh           # Environment variables
│   ├── fzf.zsh           # FZF configuration
│   ├── history.zsh       # History settings
│   ├── keybindings.zsh   # Key bindings
│   ├── languages.zsh     # Language-specific configs (node, python, ruby)
│   ├── plugins.zsh       # Plugin loading
│   ├── tools.zsh         # Tool configurations
│   └── work.zsh          # Work-specific settings
│
├── .oh-my-zsh-custom/    # Oh-My-Zsh custom plugins and themes
│   ├── plugins/          # Custom plugins
│   │   ├── aliases/      # Custom alias plugin
│   │   ├── zsh-autosuggestions/
│   │   ├── zsh-exa/
│   │   └── zsh-syntax-highlighting/
│   └── themes/           # Custom themes
│       └── powerlevel10k/
│
├── .zshrc                # Main Zsh configuration file
├── .zshrc.local          # Local machine-specific settings
├── .wezterm.lua          # Wezterm configuration
├── Brewfile              # Homebrew dependencies
├── keyboard/             # Keyboard configs (via files)
└── archive/              # Archived configurations
```

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
- **Git integration** - Delta for diffs, custom aliases
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

### Install All Configurations
```bash
cd ~/dotfiles
stow .
```

This symlinks everything to your home directory.

### Remove All Symlinks
```bash
cd ~/dotfiles
stow -D .
```

### Dry Run (Preview Changes)
```bash
stow -n .     # See what would be linked
stow -nv .    # Verbose output
```

### Restow (Update Symlinks)
```bash
stow -R .     # Useful after adding/removing files
```

### Conflicts
If stow reports conflicts (existing files that aren't symlinks):
```bash
# Backup and remove conflicting files
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/nvim ~/.config/nvim.backup

# Then stow again
stow .
```

## Editing Configurations

Since files are symlinked, edit them directly:

```bash
# These edit the files in ~/dotfiles/
vim ~/.zshrc
vim ~/.config/nvim/init.lua
vim ~/.tmux/tmux.conf
```

Changes are immediately tracked by git.

## Adding New Configurations

1. Add files to this repo matching home directory structure:
   ```bash
   # Example: Add ghostty config
   mkdir -p .config/ghostty
   echo "theme = catppuccin-mocha" > .config/ghostty/config
   ```

2. Restow to create new symlinks:
   ```bash
   stow -R .
   ```

3. Commit changes:
   ```bash
   git add .config/ghostty
   git commit -m "Add ghostty configuration"
   ```

## Customization

### Zsh
- **Add aliases**: Edit `.zsh/aliases.zsh`
- **Add functions**: Create new files in `.zsh/`
- **Environment variables**: Edit `.zsh/env.zsh`
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

# Check stow would link
stow -nv .

# Update packages
# macOS
brew bundle --file=~/dotfiles/Brewfile

# Linux (example)
sudo apt update && sudo apt upgrade

# Search history with fzf
Ctrl+R

# Smart directory navigation
z <partial-name>    # Uses zoxide
```

## Notes

- **Cross-platform**: Developed on macOS, compatible with Linux and Unix systems
- **macOS-specific configs**: Aerospace and Karabiner configs are macOS-only (ignored on other systems)
- **Brewfile**: Homebrew package list for macOS; use your distro's package manager on Linux
- **Review before use**: Contains personal settings and paths
- **Backup first**: Always backup existing configs
- **Local settings**: Use `.zshrc.local` for machine-specific config (gitignored)
- **Safe removal**: `stow -D .` cleanly removes all symlinks

## License

Personal dotfiles - feel free to use as reference or starting point.

---

*Terminal-centric development environment managed with GNU Stow for clean, reversible configuration management.*
