#!/usr/bin/env bash

# Install tools via mise
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

if ! command_exists mise; then
    log_error "mise is not installed. Please run the Homebrew module first."
    exit 1
fi

# Install neovim 0.12 and set as default
if mise ls neovim 2>/dev/null | grep -q "0.12"; then
    log_success "Neovim 0.12 already installed via mise."
else
    log_info "Installing Neovim 0.12 via mise..."
    mise use --global neovim@0.12
    if [ $? -eq 0 ]; then
        log_success "Neovim 0.12 installed and set as default via mise."
    else
        log_error "Failed to install Neovim 0.12 via mise."
        exit 1
    fi
fi
