#!/usr/bin/env bash

# Clone Neovim config repo if not present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Directories to create
mkdir -p "$HOME/dev"
mkdir -p "$HOME/temp"

# Set Dark Mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# Install gh extensions
if command_exists gh; then
    GH_EXTENSIONS=(
        dlvhdr/gh-dash
        github/gh-copilot
        meiji163/gh-notify
    )
    for ext in "${GH_EXTENSIONS[@]}"; do
        if gh extension list | grep -q "$ext"; then
            log_success "gh extension already installed: $ext"
        else
            log_info "Installing gh extension: $ext"
            gh extension install "$ext"
        fi
    done
else
    log_warn "gh is not installed. Skipping gh extensions."
fi

# Start sketchybar as a brew service
if brew list sketchybar &>/dev/null; then
    log_info "Starting sketchybar as a brew service..."
    brew services start sketchybar
    log_success "sketchybar service started."
else
    log_warn "sketchybar is not installed. Skipping service start."
fi
