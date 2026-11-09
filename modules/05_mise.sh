#!/usr/bin/env bash

# Install tools via mise
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

if ! command_exists mise; then
    log_error "mise is not installed. Please run the Homebrew module first."
    exit 1
fi

# Install Rust toolchain (rustc, cargo) — required for rust-analyzer to function.
# rust-analyzer binary is installed via Mason but cannot analyze code without rustc/stdlib.
if mise ls rust 2>/dev/null | grep -q "."; then
    log_success "Rust already installed via mise."
else
    log_info "Installing Rust via mise..."
    mise use --global rust@latest
    if [ $? -eq 0 ]; then
        log_success "Rust installed and set as default via mise."
    else
        log_error "Failed to install Rust via mise."
        exit 1
    fi
fi
