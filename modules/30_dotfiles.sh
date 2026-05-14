#!/usr/bin/env bash

# Clone dotfiles repo if not present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

DOTFILES_DIR="$HOME/dev-personal/.dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    log_info "Cloning dotfiles repository to $DOTFILES_DIR..."
    mkdir -p "$HOME/dev-personal"
    git clone https://github.com/tomerlevy1/.dotfiles "$DOTFILES_DIR"
    if [ $? -eq 0 ]; then
        log_success "Dotfiles cloned to $DOTFILES_DIR."
    else
        log_error "Failed to clone dotfiles repository."
        exit 1
    fi
else
    log_success "Dotfiles already present at $DOTFILES_DIR."
fi
