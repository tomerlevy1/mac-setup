#!/usr/bin/env bash

# Install VimMode.spoon for Hammerspoon
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

SPOON_DIR="$HOME/.hammerspoon/Spoons/VimMode.spoon"

if [ ! -d "$SPOON_DIR" ]; then
    log_info "Cloning VimMode.spoon..."
    mkdir -p "$HOME/.hammerspoon/Spoons"
    git clone https://github.com/dbalatero/VimMode.spoon "$SPOON_DIR"
    if [ $? -eq 0 ]; then
        log_success "VimMode.spoon installed at $SPOON_DIR."
    else
        log_error "Failed to clone VimMode.spoon."
        exit 1
    fi
else
    log_success "VimMode.spoon already present at $SPOON_DIR."
fi
