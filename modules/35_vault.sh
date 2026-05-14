#!/usr/bin/env bash

# Clone Obsidian vault repo if not present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

VAULT_DIR="$HOME/vaults/notes"
VAULT_REPO="https://github.com/tomerlevy1/obsidian-notes.git"

mkdir -p "$HOME/vaults"

if [ ! -d "$VAULT_DIR/.git" ]; then
    log_info "Cloning Obsidian vault to $VAULT_DIR..."
    git clone "$VAULT_REPO" "$VAULT_DIR"
    if [ $? -eq 0 ]; then
        log_success "Obsidian vault cloned to $VAULT_DIR."
    else
        log_error "Failed to clone Obsidian vault."
        exit 1
    fi
else
    log_success "Obsidian vault already present at $VAULT_DIR."
fi
