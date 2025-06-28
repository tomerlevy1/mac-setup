#!/usr/bin/env bash

# Clone dotfiles repo if not present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

if [ ! -d "$HOME/.dotfiles" ]; then
    log_info "Cloning dotfiles repository..."
    git clone https://github.com/tomerlevy1/.dotfiles "$HOME/.dotfiles"
    if [ $? -eq 0 ]; then
        log_success "Dotfiles cloned to $HOME/.dotfiles."
    else
        log_error "Failed to clone dotfiles repository."
        exit 1
    fi
else
    log_success "Dotfiles already present at $HOME/.dotfiles."
fi 