# Dotfiles

Personal dotfiles for macOS development environment with a focus on terminal-based productivity tools. Organized for [GNU Stow](https://www.gnu.org/software/stow/) symlink management.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install Homebrew dependencies
brew bundle

# Backup existing configs (recommended)
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config ~/.config.backup 2>/dev/null || true

# Use GNU Stow to create symlinks
stow .

# Alternatively, stow specific packages only:
# stow config zsh tmux
```

### What is GNU Stow?

[GNU Stow](https://www.gnu.org/software/stow/) is a symlink farm manager that creates symbolic links from a central dotfiles directory to your home directory. This allows you to:

- Keep all configs in one git repository
- Selectively enable/disable configurations
- Easily manage multiple environments
- Maintain clean separation between different tool configs

## 🛠 Core Tools

### Shell & Terminal
- **Zsh** with [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager
- **Starship** prompt with Catppuccin Mocha theme
- **Tmux** with custom keybindings and appearance
- **Wezterm** / **Ghostty** / **Kitty** terminal emulators

### Development Tools
- **Neovim** with Lua configuration and lazy.nvim
- **Git** with delta for diff highlighting
- **Node.js** with NVM auto-switching
- **Python** with pyenv
- **Ruby** with rbenv

### Productivity Tools
- **fzf** - Fuzzy file finder
- **ripgrep** - Fast text search
- **eza** - Modern ls replacement
- **bat** - Cat with syntax highlighting
- **zoxide** - Smart directory jumping
- **atuin** - Shell history replacement

### Window Management (macOS)
- **yabai** - Tiling window manager
- **skhd** - Hotkey daemon
- **Aerospace** - Alternative window manager
- **Karabiner Elements** - Keyboard customization

## 📁 Repository Structure (GNU Stow Compatible)

This repository is organized as a Stow package, where each top-level directory represents files that will be symlinked to your home directory:

```
dotfiles/
├── .config/            # → ~/.config/
│   ├── nvim/           #   → ~/.config/nvim/
│   ├── aerospace/      #   → ~/.config/aerospace/
│   ├── yabai/          #   → ~/.config/yabai/
│   ├── skhd/           #   → ~/.config/skhd/
│   ├── kitty/          #   → ~/.config/kitty/
│   ├── ghostty/        #   → ~/.config/ghostty/
│   ├── wezterm/        #   → ~/.config/wezterm/
│   ├── bat/            #   → ~/.config/bat/
│   ├── atuin/          #   → ~/.config/atuin/
│   ├── karabiner/      #   → ~/.config/karabiner/
│   ├── tmuxinator/     #   → ~/.config/tmuxinator/
│   ├── yazi/           #   → ~/.config/yazi/
│   └── ranger/         #   → ~/.config/ranger/
├── .tmux/              # → ~/.tmux/
├── .oh-my-zsh-custom/  # → ~/.oh-my-zsh-custom/
├── keyboard/           # → ~/keyboard/
├── .zshrc              # → ~/.zshrc
├── .wezterm.lua        # → ~/.wezterm.lua
├── starship.toml       # → ~/.config/starship.toml
└── Brewfile            # → ~/Brewfile

# When you run `stow .`, these paths are symlinked to your home directory
```

## ⚙️ Key Features

### Zsh Configuration
- **Plugin Management**: Zinit for fast plugin loading
- **Auto-suggestions**: Smart command completion
- **Syntax Highlighting**: Real-time syntax validation
- **History Search**: Atuin for enhanced history with sync
- **Vi Mode**: Vi-style command line editing
- **Smart Aliases**: Productivity shortcuts and git aliases

### Neovim Setup
- **Package Manager**: lazy.nvim for fast startup
- **LSP Integration**: Language server support
- **Treesitter**: Advanced syntax highlighting
- **Custom Keybindings**: Vim-style navigation and shortcuts

### Tmux Configuration
- **Modular Config**: Split into appearance, keybindings, and plugins
- **SSH Awareness**: Different configurations for local/remote sessions
- **Mouse Support**: Click and scroll support
- **Custom Status Bar**: Git-aware status line

### Development Workflow
- **Auto Node.js Switching**: NVM integration with .nvmrc support
- **Git Integration**: Delta for diffs, custom aliases
- **Project Templates**: Tmuxinator for quick project setup
- **Code Formatting**: Prettier, StyLua integration

## 🎨 Theming

Using **Catppuccin** theme across all applications:
- Starship prompt (Mocha variant)
- Bat syntax highlighting
- Atuin history viewer
- Yazi file manager
- Terminal color schemes

## 🔧 Installation Requirements

- macOS (tested on recent versions)
- **GNU Stow** (`brew install stow`) - For symlink management
- Homebrew package manager
- Git for version control

## 📝 Managing Configurations with Stow

### Install All Configurations
```bash
# Symlink all dotfiles
stow .
```

### Selective Installation
```bash
# Install only specific configurations
stow config      # Only .config/ directory
stow zsh         # Only .zshrc and .oh-my-zsh-custom/
stow tmux        # Only .tmux/ directory
```

### Remove Configurations
```bash
# Remove all symlinks
stow -D .

# Remove specific configurations
stow -D config
stow -D zsh
```

### Check What Would Be Linked
```bash
# Dry run to see what would be created
stow -n .
stow -n config
```

## 📝 Customization

### Adding New Configurations
1. Create the directory structure that mirrors your home directory
2. Add your configuration files
3. Run `stow .` to create symlinks

### Modifying Existing Configs
Since files are symlinked, edit them directly in the repository:

```bash
# Edit configurations in the repo, changes apply immediately
vim ~/.zshrc                    # Actually editing ~/dotfiles/.zshrc
vim ~/.config/nvim/init.lua     # Actually editing ~/dotfiles/.config/nvim/init.lua
```

### Adding New Aliases
Edit `.zshrc` or create files in `.oh-my-zsh-custom/plugins/aliases/`

### Modifying Tmux
Edit files in `.tmux/` directory:
- `appearance.conf` - Colors and status bar
- `keybindings.conf` - Key mappings
- `plugins.conf` - Plugin configuration

### Neovim Plugins
Add plugins in `.config/nvim/lua/lazy-plugins.lua`

## 🚨 Notes

- **GNU Stow Compatible**: Repository structure designed for stow symlink management
- Contains personal API keys and work-specific configurations
- Review and modify paths, usernames, and credentials before use
- Backup existing configurations before applying these dotfiles
- Some configurations are macOS-specific
- Use `stow -D .` to safely remove all symlinks if needed

## 📖 Useful Commands

```bash
# Reload zsh configuration
sc

# Edit zsh configuration
ec

# Start tmux session
mux

# Create new tmux workspace
bw

# Search command history
# Press Ctrl+R in terminal

# Navigate directories
cd <partial-name>  # Uses zoxide smart jumping
```

---

*These dotfiles represent a terminal-centric development workflow optimized for productivity and aesthetics. Managed with GNU Stow for clean, reversible symlink installation.*