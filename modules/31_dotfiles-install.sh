#!/usr/bin/env bash

# Run install.sh from within .dotfiles if it exists and is executable
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

DOTFILES_DIR="$HOME/dev-personal/.dotfiles"

if [ -x "$DOTFILES_DIR/install.sh" ]; then
    log_info "Running $DOTFILES_DIR/install.sh..."
    (cd "$DOTFILES_DIR" && ./install.sh)
    if [ $? -eq 0 ]; then
        log_success "dotfiles install.sh executed successfully."
    else
        log_error "dotfiles install.sh failed."
        exit 1
    fi
else
    log_info "$DOTFILES_DIR/install.sh not found or not executable; skipping."
fi
