#!/usr/bin/env bash

# Clone Neovim 0.12 config repo and symlink to ~/.config/nvim12
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

REPO_DIR="$HOME/dev-personal/nvim12"
CONFIG_LINK="$HOME/.config/nvim12"

mkdir -p "$HOME/dev-personal"
mkdir -p "$HOME/.config"

if [ ! -d "$REPO_DIR" ]; then
    log_info "Cloning nvim12 configuration repository..."
    git clone https://github.com/tomerlevy1/nvim12.git "$REPO_DIR"
    if [ $? -eq 0 ]; then
        log_success "nvim12 config cloned to $REPO_DIR."
    else
        log_error "Failed to clone nvim12 config repository."
        exit 1
    fi
else
    log_success "nvim12 config already present at $REPO_DIR."
fi

if [ ! -L "$CONFIG_LINK" ]; then
    ln -s "$REPO_DIR" "$CONFIG_LINK"
    log_success "Symlinked $CONFIG_LINK -> $REPO_DIR."
else
    log_success "Symlink already exists at $CONFIG_LINK."
fi