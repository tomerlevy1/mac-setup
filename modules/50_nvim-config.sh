#!/usr/bin/env bash

# Clone Neovim config repo if not present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

mkdir -p "$HOME/.config"

if [ ! -d "$HOME/.config/nvim" ]; then
    log_info "Cloning Neovim configuration repository..."
    git clone https://github.com/tomerlevy1/nvim "$HOME/.config/nvim"
    if [ $? -eq 0 ]; then
        log_success "Neovim config cloned to $HOME/.config/nvim."
    else
        log_error "Failed to clone Neovim config repository."
        exit 1
    fi
else
    log_success "Neovim config already present at $HOME/.config/nvim."
fi 