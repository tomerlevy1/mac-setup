#!/usr/bin/env bash

# Run install.sh from within .dotfiles if it exists and is executable
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

if [ -x "$HOME/.dotfiles/install.sh" ]; then
    log_info "Running .dotfiles/install.sh..."
    (cd "$HOME/.dotfiles" && ./install.sh)
    if [ $? -eq 0 ]; then
        log_success ".dotfiles/install.sh executed successfully."
    else
        log_error ".dotfiles/install.sh failed."
        exit 1
    fi
else
    log_info ".dotfiles/install.sh not found or not executable; skipping."
fi 