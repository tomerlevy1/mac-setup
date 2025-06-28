#!/usr/bin/env bash

# Clone Neovim config repo if not present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Directories to create
mkdir -p "$HOME/dev"
mkdir -p "$HOME/temp"

# Set Dark Mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
