#!/usr/bin/env bash

# macOS keyboard shortcut overrides (com.apple.symbolichotkeys).
#
# Targets:
#   - Free Cmd+Space   -> disable Spotlight so Raycast can claim it
#   - Free Ctrl+Space  -> Neovim uses it for completion
#   - Bind Opt+Space   -> "Select previous input source" (language switch)
#
# Hotkey IDs (Apple-internal):
#   60 = Select previous input source
#   61 = Select next input source in input menu
#   64 = Show Spotlight search
#   65 = Show Finder search window
#
# Parameter tuple: (ascii, keycode, modifier-mask). Space = 49 / ASCII 32.
# Modifier masks: cmd=1048576 shift=131072 opt=524288 ctrl=262144.
#
# IMPORTANT: cfprefsd caches these values. We kill it after writing so the
# changes take effect without a logout. The Raycast hotkey itself must be
# set inside Raycast's settings UI (Cmd+Space) — Raycast doesn't expose a
# scriptable preference for it.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

PLIST="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
PB=/usr/libexec/PlistBuddy

set_hotkey() {
    local id="$1" enabled="$2" ascii="$3" keycode="$4" mods="$5"
    # Wipe any prior entry so we can rewrite cleanly
    $PB -c "Delete :AppleSymbolicHotKeys:$id" "$PLIST" 2>/dev/null || true
    $PB -c "Add :AppleSymbolicHotKeys:$id dict" "$PLIST"
    $PB -c "Add :AppleSymbolicHotKeys:$id:enabled bool $enabled" "$PLIST"
    $PB -c "Add :AppleSymbolicHotKeys:$id:value dict" "$PLIST"
    $PB -c "Add :AppleSymbolicHotKeys:$id:value:type string standard" "$PLIST"
    $PB -c "Add :AppleSymbolicHotKeys:$id:value:parameters array" "$PLIST"
    $PB -c "Add :AppleSymbolicHotKeys:$id:value:parameters: integer $ascii" "$PLIST"
    $PB -c "Add :AppleSymbolicHotKeys:$id:value:parameters: integer $keycode" "$PLIST"
    $PB -c "Add :AppleSymbolicHotKeys:$id:value:parameters: integer $mods" "$PLIST"
}

log_info "Disabling Spotlight (Cmd+Space) and Finder-search (Opt+Cmd+Space)..."
set_hotkey 64 false 32 49 1048576   # Spotlight       -> Cmd+Space (disabled)
set_hotkey 65 false 32 49 1572864   # Finder search   -> Opt+Cmd+Space (disabled)

log_info "Rebinding input-source switcher to Opt+Space, freeing Ctrl+Space..."
set_hotkey 60 true  32 49 524288    # Prev input src  -> Opt+Space (enabled)
set_hotkey 61 false 32 49 786432    # Next input src  -> Ctrl+Opt+Space (disabled)

# cfprefsd caches the plist; reload it so symbolichotkeys picks up the changes.
killall cfprefsd >/dev/null 2>&1 || true

log_success "Keyboard shortcuts updated."
log_warn "Open Raycast settings and bind its hotkey to Cmd+Space (now free)."
log_warn "Some changes only take full effect after logout or reboot."
