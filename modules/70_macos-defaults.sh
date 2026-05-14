#!/usr/bin/env bash

# macOS system defaults
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

log_info "Applying macOS defaults..."

# --- Keyboard ---
# Fastest key repeat + short initial delay (essential for vim-style nav)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable press-and-hold (so hjkl repeat works everywhere, incl. browsers)
defaults write -g ApplePressAndHoldEnabled -bool false
# Disable autocorrect / smart quotes / smart dashes (annoying for dev typing)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# --- Mouse / Trackpad (match current machine) ---
# Natural scrolling OFF (reverse direction)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# Tap-to-click ON
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write -g com.apple.mouse.tapBehavior -int 1
# 3-finger drag OFF (already default)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
# Swipe-between-pages with scroll OFF
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool false

# --- Finder ---
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Default to list view (Nlsv) when opening new windows
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Don't write .DS_Store to network / USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock tilesize -int 36
# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# --- Reduced animations (system-wide) ---
defaults write com.apple.universalaccess reduceMotion -bool true
defaults write com.apple.universalaccess reduceTransparency -bool true
# Speed up window resize / open / close animations
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
# Faster Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

log_success "macOS defaults applied."

# Restart affected services so changes take effect immediately
log_info "Restarting Finder, Dock, SystemUIServer..."
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true

log_warn "Some defaults (keyboard repeat, reduced motion) require a logout/restart to fully apply."
