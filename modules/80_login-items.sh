#!/usr/bin/env bash

# Register GUI apps as login items and launch them now so they're running
# after a fresh setup. Idempotent: skips if already registered / running.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Apps that should auto-start on login and be running after setup.
# Format: "AppName:/Applications/AppName.app"
LOGIN_APPS=(
    "Raycast:/Applications/Raycast.app"
    "AeroSpace:/Applications/AeroSpace.app"
    "Karabiner-Elements:/Applications/Karabiner-Elements.app"
    "Maccy:/Applications/Maccy.app"
    "noTunes:/Applications/noTunes.app"
)

add_login_item() {
    local name="$1"
    local path="$2"

    if [[ ! -d "$path" ]]; then
        log_warn "$name not installed at $path — skipping."
        return
    fi

    # Check if already a login item
    local existing
    existing=$(osascript -e "tell application \"System Events\" to get the name of every login item" 2>/dev/null || echo "")
    if echo "$existing" | grep -qi "$name"; then
        log_success "$name already registered as login item."
    else
        log_info "Registering $name as login item..."
        osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$path\", hidden:false}" >/dev/null
        log_success "$name added to login items."
    fi

    # Launch if not running
    if pgrep -xq "$name"; then
        log_success "$name already running."
    else
        log_info "Launching $name..."
        open -a "$path"
    fi
}

for entry in "${LOGIN_APPS[@]}"; do
    name="${entry%%:*}"
    path="${entry#*:}"
    add_login_item "$name" "$path"
done

log_warn "First launch of Raycast/AeroSpace may require granting Accessibility permissions in System Settings."
