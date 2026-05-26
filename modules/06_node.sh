#!/usr/bin/env bash

# Install Node.js LTS via fnm
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

if ! command_exists fnm; then
    log_error "fnm is not installed. Please run the Homebrew module first."
    exit 1
fi

eval "$(fnm env --shell bash)"

if fnm ls 2>/dev/null | grep -qE "lts-latest|v[0-9]+\.[0-9]+\.[0-9]+"; then
    log_success "Node.js already installed via fnm."
else
    log_info "Installing Node.js LTS via fnm..."
    if fnm install --lts && fnm default lts-latest; then
        log_success "Node.js LTS installed and set as default via fnm."
    else
        log_error "Failed to install Node.js LTS via fnm."
        exit 1
    fi
fi
