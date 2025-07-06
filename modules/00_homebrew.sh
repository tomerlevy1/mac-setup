#!/usr/bin/env bash

# Homebrew installation and package management module
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Ensure Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    log_success "Xcode Command Line Tools installation triggered. Please follow the prompts."
else
    log_success "Xcode Command Line Tools are already installed."
    log_warn "To update Xcode Command Line Tools, use Software Update or reinstall manually if needed. (This cannot be done automatically by the script.)"
fi

# Required taps, casks, and formulae
TAPS=(
    homebrew/cask-fonts
    koekeishiya/formulae
    FelixKratz/formulae
    espanso/espanso
    cirruslabs/cli
    hashicorp/tap
)
CASKS=(
    font-jetbrains-mono-nerd-font
    font-0xproto-nerd-font
    maccy
    karabiner-elements
    ghostty
    obsidian
    google-chrome
    mysqlworkbench
    raycast
    visual-studio-code
)
FORMULAE=(
    bat
    cirruslabs/cli/tart
    commitizen
    espanso
    eza
    fd
    fnm
    fzf
    gh
    git
    git-delta
    hashicorp/tap/terraform
    jq
    lazygit
    less
    neovim
    ripgrep
    sketchybar
    skhd
    starship
    stow
    tldr
    tmux
    tree
    yabai
    yq
    z
    zsh
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
)

# Ensure Homebrew is installed
if ! command_exists brew; then
    log_error "Homebrew is not installed. Please run the Homebrew installation step first."
    exit 1
fi

# Tap required repositories
for tap in "${TAPS[@]}"; do
    if brew tap | grep -q "^$tap$"; then
        log_success "Tap already added: $tap"
    else
        log_info "Adding tap: $tap"
        brew tap "$tap"
    fi
done

# Install required casks
for cask in "${CASKS[@]}"; do
    if brew list --cask | grep -q "^$cask$"; then
        log_success "Cask already installed: $cask"
    else
        log_info "Installing cask: $cask"
        brew install --cask "$cask"
    fi
done

# Install required formulae
for formula in "${FORMULAE[@]}"; do
    if brew list | grep -q "^$formula$"; then
        log_success "Formula already installed: $formula"
    else
        log_info "Installing formula: $formula"
        brew install "$formula"
    fi
done

# --- Compare installed vs required ---

# Get installed lists
INSTALLED_FORMULAE=( $(brew list) )
INSTALLED_CASKS=( $(brew list --cask) )

# Find missing formulae
MISSING_FORMULAE=()
for formula in "${FORMULAE[@]}"; do
    if ! printf '%s\n' "${INSTALLED_FORMULAE[@]}" | grep -qx "$formula"; then
        MISSING_FORMULAE+=("$formula")
    fi
done

# Find extra formulae
EXTRA_FORMULAE=()
for formula in "${INSTALLED_FORMULAE[@]}"; do
    if ! printf '%s\n' "${FORMULAE[@]}" | grep -qx "$formula"; then
        EXTRA_FORMULAE+=("$formula")
    fi
done

# Find missing casks
MISSING_CASKS=()
for cask in "${CASKS[@]}"; do
    if ! printf '%s\n' "${INSTALLED_CASKS[@]}" | grep -qx "$cask"; then
        MISSING_CASKS+=("$cask")
    fi
done

# Find extra casks
EXTRA_CASKS=()
for cask in "${INSTALLED_CASKS[@]}"; do
    if ! printf '%s\n' "${CASKS[@]}" | grep -qx "$cask"; then
        EXTRA_CASKS+=("$cask")
    fi
done

# Log results
if [ ${#MISSING_FORMULAE[@]} -eq 0 ]; then
    log_success "All required formulae are installed."
else
    log_error "Missing formulae: ${MISSING_FORMULAE[*]}"
fi

if [ ${#EXTRA_FORMULAE[@]} -eq 0 ]; then
    log_success "No extra formulae installed."
else
    log_info "Extra formulae installed: ${EXTRA_FORMULAE[*]}"
fi

if [ ${#MISSING_CASKS[@]} -eq 0 ]; then
    log_success "All required casks are installed."
else
    log_error "Missing casks: ${MISSING_CASKS[*]}"
fi

if [ ${#EXTRA_CASKS[@]} -eq 0 ]; then
    log_success "No extra casks installed."
else
    log_info "Extra casks installed: ${EXTRA_CASKS[*]}"
fi
