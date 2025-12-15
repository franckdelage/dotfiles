#!/usr/bin/env bash

# =============================================================================
# Dotfiles Bootstrap Installer
# Interactive installation script for Unix-based systems (macOS & Linux)
# =============================================================================

set -e  # Exit on error

# -----------------------------------------------------------------------------
# Colors and Formatting
# -----------------------------------------------------------------------------
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  MAGENTA='\033[0;35m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  RESET='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  MAGENTA=''
  CYAN=''
  BOLD=''
  RESET=''
fi

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

log_info() {
  echo -e "${BLUE}[i]${RESET} $1"
}

log_success() {
  echo -e "${GREEN}[✓]${RESET} $1"
}

log_warning() {
  echo -e "${YELLOW}[!]${RESET} $1"
}

log_error() {
  echo -e "${RED}[✗]${RESET} $1"
}

log_step() {
  echo ""
  echo -e "${CYAN}${BOLD}$1${RESET}"
  echo "$(printf '─%.0s' {1..50})"
}

ask_yes_no() {
  local prompt="$1"
  local default="${2:-n}"  # Default to 'n' if not specified
  local response
  
  if [[ "$default" == "y" ]]; then
    prompt="${prompt} (Y/n)"
  else
    prompt="${prompt} (y/N)"
  fi
  
  while true; do
    echo -en "${MAGENTA}[?]${RESET} ${prompt}: "
    read -r response
    response="${response,,}"  # Convert to lowercase
    
    # If empty, use default
    if [[ -z "$response" ]]; then
      response="$default"
    fi
    
    case "$response" in
      y|yes) return 0 ;;
      n|no) return 1 ;;
      *) echo "Please answer yes or no." ;;
    esac
  done
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# -----------------------------------------------------------------------------
# Platform Detection
# -----------------------------------------------------------------------------

detect_platform() {
  case "$(uname -s)" in
    Darwin*)
      PLATFORM="macos"
      log_success "Running on: macOS (Darwin)"
      ;;
    Linux*)
      PLATFORM="linux"
      log_success "Running on: Linux"
      detect_linux_distro
      ;;
    *)
      log_error "Unsupported operating system: $(uname -s)"
      exit 1
      ;;
  esac
}

detect_linux_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO="$ID"
    
    case "$DISTRO" in
      ubuntu|debian)
        PKG_MANAGER="apt"
        log_info "Detected: $NAME (using apt)"
        ;;
      fedora|rhel|centos)
        PKG_MANAGER="dnf"
        log_info "Detected: $NAME (using dnf)"
        ;;
      arch|manjaro)
        PKG_MANAGER="pacman"
        log_info "Detected: $NAME (using pacman)"
        ;;
      opensuse*)
        PKG_MANAGER="zypper"
        log_info "Detected: $NAME (using zypper)"
        ;;
      *)
        PKG_MANAGER="unknown"
        log_warning "Unknown Linux distribution: $NAME"
        ;;
    esac
  else
    DISTRO="unknown"
    PKG_MANAGER="unknown"
    log_warning "Could not detect Linux distribution"
  fi
}

# -----------------------------------------------------------------------------
# Pre-flight Checks
# -----------------------------------------------------------------------------

preflight_checks() {
  log_step "Pre-flight Checks"
  
  # Check if git is installed
  if ! command_exists git; then
    log_error "Git is not installed. Please install git first."
    exit 1
  fi
  log_success "Git is installed"
  
  # Check if we're in the dotfiles directory
  if [[ ! -f "Brewfile" ]] || [[ ! -d ".config" ]]; then
    log_error "This script must be run from the dotfiles directory"
    log_info "Expected files: Brewfile, .config/"
    exit 1
  fi
  log_success "Running from dotfiles directory: $(pwd)"
  
  # Check if stow is installed
  if ! command_exists stow; then
    log_warning "GNU Stow is not installed"
    if [[ "$PLATFORM" == "macos" ]]; then
      if command_exists brew; then
        if ask_yes_no "Install GNU Stow via Homebrew" "y"; then
          brew install stow
          log_success "GNU Stow installed"
        else
          log_error "GNU Stow is required. Install it with: brew install stow"
          exit 1
        fi
      else
        log_error "Homebrew not found. Please install Stow manually or install Homebrew first."
        exit 1
      fi
    else
      log_error "GNU Stow is required. Please install it first."
      log_info "Debian/Ubuntu: sudo apt install stow"
      log_info "Fedora: sudo dnf install stow"
      log_info "Arch: sudo pacman -S stow"
      exit 1
    fi
  else
    log_success "GNU Stow is installed"
  fi
}

# -----------------------------------------------------------------------------
# Backup Existing Configs
# -----------------------------------------------------------------------------

backup_configs() {
  log_step "STEP 1: Backup Existing Configs"
  
  if ! ask_yes_no "Create backup of existing configs" "n"; then
    log_info "Skipping backup"
    return 0
  fi
  
  BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_DIR"
  log_success "Created backup directory: $BACKUP_DIR"
  
  local backed_up=0
  local items_to_backup=(
    ".zshrc"
    ".zshrc.local"
    ".config/nvim"
    ".config/tmux"
    ".config/aerospace"
    ".config/yazi"
    ".config/atuin"
    ".config/bat"
    ".config/karabiner"
    ".config/wezterm"
    ".config/starship.toml"
    ".tmux"
    ".wezterm.lua"
    ".oh-my-zsh-custom"
    ".zsh"
  )
  
  for item in "${items_to_backup[@]}"; do
    if [[ -e "$HOME/$item" ]] && [[ ! -L "$HOME/$item" ]]; then
      log_info "Backing up: ~/$item"
      mkdir -p "$(dirname "$BACKUP_DIR/$item")"
      mv "$HOME/$item" "$BACKUP_DIR/$item"
      ((backed_up++))
    fi
  done
  
  if [[ $backed_up -eq 0 ]]; then
    log_info "No existing configs found to backup"
    rmdir "$BACKUP_DIR" 2>/dev/null || true
  else
    log_success "$backed_up items backed up to $BACKUP_DIR"
    echo "$BACKUP_DIR" > "$HOME/.dotfiles-backup-location"
  fi
}

# -----------------------------------------------------------------------------
# Install System Packages
# -----------------------------------------------------------------------------

install_packages_macos() {
  if ! command_exists brew; then
    log_error "Homebrew is not installed"
    log_info "Install Homebrew from: https://brew.sh"
    return 1
  fi
  
  log_info "Running: brew bundle --file=Brewfile"
  if brew bundle --file=Brewfile; then
    log_success "Homebrew packages installed"
  else
    log_warning "Some Homebrew packages may have failed to install"
  fi
}

install_packages_linux() {
  log_info "Attempting to install packages via $PKG_MANAGER"
  
  # Essential packages that should be available on most distros
  local essential_packages=(
    "stow"
    "zsh"
    "tmux"
    "neovim"
    "git"
    "fzf"
    "ripgrep"
  )
  
  # Packages with varying names/availability
  local optional_packages=(
    "bat"        # May be 'batcat' on Debian/Ubuntu
    "eza"        # May not be in all repos
    "zoxide"     # May need manual install
    "starship"   # May need manual install
    "git-delta"  # May be named differently
  )
  
  local failed_packages=()
  
  case "$PKG_MANAGER" in
    apt)
      log_info "Updating package list..."
      sudo apt update
      
      for pkg in "${essential_packages[@]}"; do
        log_info "Installing: $pkg"
        if ! sudo apt install -y "$pkg" 2>/dev/null; then
          failed_packages+=("$pkg")
        fi
      done
      
      # Try optional packages
      for pkg in "${optional_packages[@]}"; do
        log_info "Attempting to install: $pkg"
        if [[ "$pkg" == "bat" ]]; then
          # Debian/Ubuntu uses 'batcat'
          if ! sudo apt install -y bat 2>/dev/null; then
            sudo apt install -y batcat 2>/dev/null || failed_packages+=("bat/batcat")
          fi
        else
          sudo apt install -y "$pkg" 2>/dev/null || failed_packages+=("$pkg")
        fi
      done
      ;;
      
    dnf)
      for pkg in "${essential_packages[@]}"; do
        log_info "Installing: $pkg"
        if ! sudo dnf install -y "$pkg" 2>/dev/null; then
          failed_packages+=("$pkg")
        fi
      done
      
      for pkg in "${optional_packages[@]}"; do
        log_info "Attempting to install: $pkg"
        sudo dnf install -y "$pkg" 2>/dev/null || failed_packages+=("$pkg")
      done
      ;;
      
    pacman)
      log_info "Updating package database..."
      sudo pacman -Sy
      
      for pkg in "${essential_packages[@]}"; do
        log_info "Installing: $pkg"
        if ! sudo pacman -S --noconfirm "$pkg" 2>/dev/null; then
          failed_packages+=("$pkg")
        fi
      done
      
      for pkg in "${optional_packages[@]}"; do
        log_info "Attempting to install: $pkg"
        sudo pacman -S --noconfirm "$pkg" 2>/dev/null || failed_packages+=("$pkg")
      done
      ;;
      
    zypper)
      for pkg in "${essential_packages[@]}"; do
        log_info "Installing: $pkg"
        if ! sudo zypper install -y "$pkg" 2>/dev/null; then
          failed_packages+=("$pkg")
        fi
      done
      
      for pkg in "${optional_packages[@]}"; do
        log_info "Attempting to install: $pkg"
        sudo zypper install -y "$pkg" 2>/dev/null || failed_packages+=("$pkg")
      done
      ;;
      
    *)
      log_error "Unknown package manager: $PKG_MANAGER"
      return 1
      ;;
  esac
  
  if [[ ${#failed_packages[@]} -gt 0 ]]; then
    log_warning "The following packages failed to install or were not found:"
    for pkg in "${failed_packages[@]}"; do
      echo "  - $pkg"
    done
    echo ""
    log_info "Manual installation instructions:"
    
    for pkg in "${failed_packages[@]}"; do
      case "$pkg" in
        eza)
          echo "  eza: cargo install eza  OR  https://github.com/eza-community/eza"
          ;;
        zoxide)
          echo "  zoxide: curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
          ;;
        starship)
          echo "  starship: curl -sS https://starship.rs/install.sh | sh"
          ;;
        git-delta)
          echo "  git-delta: https://github.com/dandavison/delta"
          ;;
        "bat/batcat")
          echo "  bat: Install 'batcat' package, then create alias: ln -s /usr/bin/batcat ~/.local/bin/bat"
          ;;
      esac
    done
  else
    log_success "All packages installed successfully"
  fi
}

install_packages() {
  log_step "STEP 2: Install System Packages"
  
  if ! ask_yes_no "Install system packages via package manager" "y"; then
    log_info "Skipping package installation"
    return 0
  fi
  
  if [[ "$PLATFORM" == "macos" ]]; then
    install_packages_macos
  else
    install_packages_linux
  fi
}

# -----------------------------------------------------------------------------
# Install TPM (Tmux Plugin Manager)
# -----------------------------------------------------------------------------

install_tpm() {
  log_step "STEP 3: Install Tmux Plugin Manager (TPM)"
  
  if ! ask_yes_no "Install Tmux Plugin Manager" "y"; then
    log_info "Skipping TPM installation"
    return 0
  fi
  
  local tpm_dir="$HOME/.tmux-plugins/tpm"
  
  if [[ -d "$tpm_dir" ]]; then
    log_info "TPM already installed at: $tpm_dir"
    if ask_yes_no "Update existing TPM installation" "n"; then
      log_info "Updating TPM..."
      git -C "$tpm_dir" pull
      log_success "TPM updated"
    fi
  else
    log_info "Cloning TPM to: $tpm_dir"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    log_success "TPM installed"
  fi
  
  log_info "Tmux plugins will be installed on first tmux launch (or press: prefix + I)"
}

# -----------------------------------------------------------------------------
# Symlink Dotfiles with Stow
# -----------------------------------------------------------------------------

symlink_dotfiles() {
  log_step "STEP 4: Symlink Dotfiles with GNU Stow"
  
  if ! ask_yes_no "Create symlinks with GNU Stow" "y"; then
    log_info "Skipping symlinking"
    return 0
  fi
  
  log_info "Running: stow --verbose=2 ."
  
  if stow --verbose=2 . 2>&1 | tee /tmp/stow-output.log; then
    log_success "Dotfiles symlinked successfully"
    
    # Show what was linked
    local linked_count=$(grep -c "LINK:" /tmp/stow-output.log 2>/dev/null || echo "0")
    if [[ $linked_count -gt 0 ]]; then
      log_success "Created $linked_count symlinks"
      log_info "Key symlinks created:"
      echo "  ~/.zshrc -> $(pwd)/.zshrc"
      echo "  ~/.config -> $(pwd)/.config"
      echo "  ~/.tmux -> $(pwd)/.tmux"
      echo "  ~/.wezterm.lua -> $(pwd)/.wezterm.lua"
    fi
  else
    log_error "Stow failed. Check the output above for conflicts."
    log_info "You may need to backup/remove conflicting files first."
    
    if ask_yes_no "Show stow conflicts" "y"; then
      cat /tmp/stow-output.log
    fi
    
    return 1
  fi
  
  rm -f /tmp/stow-output.log
}

# -----------------------------------------------------------------------------
# Post-Install Setup
# -----------------------------------------------------------------------------

post_install() {
  log_step "STEP 5: Post-Install Setup"
  
  # Set zsh as default shell
  if [[ "$SHELL" != *"zsh"* ]]; then
    if ask_yes_no "Set zsh as default shell" "n"; then
      local zsh_path
      zsh_path="$(command -v zsh)"
      
      if [[ -n "$zsh_path" ]]; then
        log_info "Changing default shell to: $zsh_path"
        
        # Add zsh to /etc/shells if not present
        if ! grep -q "$zsh_path" /etc/shells 2>/dev/null; then
          log_info "Adding $zsh_path to /etc/shells (requires sudo)"
          echo "$zsh_path" | sudo tee -a /etc/shells
        fi
        
        if chsh -s "$zsh_path"; then
          log_success "Default shell changed to zsh"
          log_info "You'll need to log out and back in for this to take effect"
        else
          log_warning "Failed to change default shell. You may need to do this manually."
        fi
      else
        log_error "Could not find zsh binary"
      fi
    fi
  else
    log_success "Zsh is already the default shell"
  fi
  
  # Install tmux plugins automatically
  if [[ -d "$HOME/.tmux-plugins/tpm" ]] && [[ -f "$HOME/.tmux-plugins/tpm/bin/install_plugins" ]]; then
    if ask_yes_no "Install tmux plugins now" "y"; then
      log_info "Installing tmux plugins..."
      if "$HOME/.tmux-plugins/tpm/bin/install_plugins"; then
        log_success "Tmux plugins installed"
      else
        log_warning "Some tmux plugins may have failed to install"
        log_info "You can install them manually by launching tmux and pressing: prefix + I"
      fi
    fi
  fi
  
  # Create .zshrc.local if it doesn't exist
  if [[ ! -f "$HOME/.zshrc.local" ]]; then
    log_info "Creating ~/.zshrc.local for machine-specific configuration"
    cat > "$HOME/.zshrc.local" << 'EOF'
# Machine-specific zsh configuration
# This file is not tracked by git and is sourced by .zshrc
# Add any local paths, aliases, or environment variables here

EOF
    log_success "Created ~/.zshrc.local"
  fi
}

# -----------------------------------------------------------------------------
# Verification
# -----------------------------------------------------------------------------

verify_installation() {
  log_step "Verifying Installation"
  
  local errors=0
  
  # Check symlinks
  local symlinks=(
    "$HOME/.zshrc"
    "$HOME/.config/nvim"
    "$HOME/.tmux"
  )
  
  log_info "Checking critical symlinks..."
  for link in "${symlinks[@]}"; do
    if [[ -L "$link" ]]; then
      log_success "✓ $link"
    else
      log_warning "✗ $link (not a symlink)"
      ((errors++))
    fi
  done
  
  # Check commands
  local commands=(
    "zsh"
    "tmux"
    "nvim"
    "git"
    "fzf"
    "rg"
    "stow"
  )
  
  echo ""
  log_info "Checking available commands..."
  for cmd in "${commands[@]}"; do
    if command_exists "$cmd"; then
      log_success "✓ $cmd"
    else
      log_warning "✗ $cmd (not found)"
      ((errors++))
    fi
  done
  
  # Optional commands
  local optional_commands=("bat" "eza" "zoxide" "starship" "delta")
  echo ""
  log_info "Checking optional commands..."
  for cmd in "${optional_commands[@]}"; do
    if command_exists "$cmd"; then
      log_success "✓ $cmd"
    else
      log_info "○ $cmd (optional, not installed)"
    fi
  done
  
  return $errors
}

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------

print_summary() {
  log_step "✨ Installation Complete!"
  
  echo ""
  echo -e "${GREEN}${BOLD}Summary:${RESET}"
  
  if [[ -n "$BACKUP_DIR" ]] && [[ -d "$BACKUP_DIR" ]]; then
    echo -e "  ${GREEN}✓${RESET} Backed up configs to: $BACKUP_DIR"
  fi
  
  echo -e "  ${GREEN}✓${RESET} Installed system packages"
  
  if [[ -d "$HOME/.tmux-plugins/tpm" ]]; then
    echo -e "  ${GREEN}✓${RESET} Installed TPM"
  fi
  
  if [[ -L "$HOME/.zshrc" ]]; then
    echo -e "  ${GREEN}✓${RESET} Created symlinks"
  fi
  
  if [[ -f "$HOME/.zshrc.local" ]]; then
    echo -e "  ${GREEN}✓${RESET} Created ~/.zshrc.local"
  fi
  
  echo ""
  echo -e "${CYAN}${BOLD}Next Steps:${RESET}"
  echo ""
  echo "  ${BOLD}1.${RESET} Reload your shell:"
  echo "     ${BLUE}\$ exec zsh${RESET}"
  echo ""
  echo "  ${BOLD}2.${RESET} Open Neovim to install plugins:"
  echo "     ${BLUE}\$ nvim${RESET}"
  echo "     ${YELLOW}(lazy.nvim will auto-install plugins)${RESET}"
  echo ""
  echo "  ${BOLD}3.${RESET} Launch tmux to verify plugins:"
  echo "     ${BLUE}\$ tmux${RESET}"
  echo "     ${YELLOW}(or press prefix + I to install plugins)${RESET}"
  echo ""
  echo "  ${BOLD}4.${RESET} Verify zinit installed plugins:"
  echo "     ${BLUE}\$ zinit list${RESET}"
  echo ""
  echo "  ${BOLD}5.${RESET} Add machine-specific config to:"
  echo "     ${BLUE}~/.zshrc.local${RESET}"
  echo ""
  
  if [[ -n "$BACKUP_DIR" ]] && [[ -d "$BACKUP_DIR" ]]; then
    echo -e "${YELLOW}Note:${RESET} Your old configs are backed up in:"
    echo "      $BACKUP_DIR"
    echo ""
  fi
  
  echo -e "${MAGENTA}Enjoy your dotfiles! 🚀${RESET}"
  echo ""
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
  clear
  echo -e "${CYAN}${BOLD}"
  echo "╔════════════════════════════════════╗"
  echo "║  Dotfiles Bootstrap Installer      ║"
  echo "╚════════════════════════════════════╝"
  echo -e "${RESET}"
  
  detect_platform
  preflight_checks
  backup_configs
  install_packages
  install_tpm
  symlink_dotfiles
  post_install
  verify_installation
  print_summary
}

# Run main function
main "$@"
