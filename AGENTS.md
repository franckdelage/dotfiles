# Agent Instructions for Dotfiles Repository

## Build/Test/Lint Commands
- No specific build commands - this is a dotfiles repository
- Config validation: Check syntax with specific tools (e.g., `nvim --headless -c "checkhealth"` for Neovim configs)
- Shell config test: `zsh -n ~/.zshrc` to validate zsh syntax

## Code Style Guidelines
- **Tabs/Spaces**: Use 2 spaces for indentation (Lua, TOML, YAML configs)
- **Shell Scripts**: Follow POSIX standards, use `shellcheck` for validation  
- **Lua (Neovim)**: Follow vim.opt syntax, group related settings, use descriptive variable names
- **Config Files**: Maintain existing format and structure, preserve comments
- **Line Length**: Keep lines under 100 characters where possible

## Naming Conventions
- **Files**: Use lowercase with hyphens (e.g., `aerospace.toml`, `yazi.toml`)
- **Directories**: Use lowercase descriptive names (e.g., `.config/nvim/lua/plugins/`)
- **Variables**: Use snake_case for shell/lua variables, SCREAMING_SNAKE_CASE for exports
- **Aliases**: Use short, memorable names that don't conflict with existing commands

## Error Handling
- **Shell**: Always check command success with `|| return 1` for functions
- **Configs**: Validate paths exist before sourcing/including
- **Conditionals**: Use `command -v` to check if programs exist before using them

## Dependencies
- Primary tools: nvim, tmux, zsh, starship, fzf, ripgrep, eza, bat, git, node/npm
- Package management: Homebrew (macOS), managed via Brewfile
- Plugin managers: zinit (zsh), lazy.nvim (neovim), tmux plugin manager