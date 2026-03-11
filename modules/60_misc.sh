#!/usr/bin/env bash

# Clone Neovim config repo if not present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Directories to create
mkdir -p "$HOME/dev"
mkdir -p "$HOME/temp"

# Set Dark Mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# Start sketchybar as a brew service
if brew list sketchybar &>/dev/null; then
    log_info "Starting sketchybar as a brew service..."
    brew services start sketchybar
    log_success "sketchybar service started."
else
    log_warn "sketchybar is not installed. Skipping service start."
fi
