#!/usr/bin/env bash

# Clone Obsidian vault repo if not present
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

VAULT_DIR="$HOME/vaults/notes"
VAULT_REPO="https://github.com/tomerlevy1/obsidian-notes.git"

mkdir -p "$HOME/vaults"

# The vault may be either a git clone OR a symlink to an iCloud-synced
# Obsidian vault. Treat either as "already present" and skip cloning.
if [ -L "$VAULT_DIR" ]; then
    log_success "Obsidian vault is a symlink at $VAULT_DIR -> $(readlink "$VAULT_DIR")."
elif [ -d "$VAULT_DIR/.git" ]; then
    log_success "Obsidian vault already cloned at $VAULT_DIR."
elif [ -e "$VAULT_DIR" ]; then
    log_warn "$VAULT_DIR exists but is neither a git clone nor a symlink — leaving it alone."
else
    log_info "Cloning Obsidian vault to $VAULT_DIR..."
    if git clone "$VAULT_REPO" "$VAULT_DIR"; then
        log_success "Obsidian vault cloned to $VAULT_DIR."
    else
        log_error "Failed to clone Obsidian vault."
        exit 1
    fi
fi
