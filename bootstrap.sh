#!/usr/bin/env bash

# bootstrap.sh — single-command fresh-Mac setup.
#
# Usage on a brand-new Mac:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomerlevy1/mac-setup/main/bootstrap.sh)"
#
# Steps:
#   1. Install Xcode Command Line Tools (provides git, compilers).
#   2. Install Homebrew (under /opt/homebrew on Apple Silicon).
#   3. Clone mac-setup repo to ~/dev/mac-setup.
#   4. Run ./setup.sh (unattended modules).
#   5. Print next-step instructions for interactive setup.

set -euo pipefail

GREEN='\033[1;32m'; YELLOW='\033[1;33m'; BLUE='\033[1;34m'; RED='\033[1;31m'; NC='\033[0m'
info()    { printf "${BLUE}[BOOTSTRAP]${NC} %s\n" "$1"; }
ok()      { printf "${GREEN}[BOOTSTRAP]${NC} %s\n" "$1"; }
warn()    { printf "${YELLOW}[BOOTSTRAP]${NC} %s\n" "$1"; }
err()     { printf "${RED}[BOOTSTRAP]${NC} %s\n" "$1" >&2; }

REPO_URL="https://github.com/tomerlevy1/mac-setup.git"
REPO_DIR="$HOME/dev/mac-setup"

# --- 1. Xcode CLT ---
if xcode-select -p &>/dev/null; then
    ok "Xcode Command Line Tools already installed."
else
    info "Installing Xcode Command Line Tools (GUI prompt will appear)..."
    xcode-select --install || true
    info "Waiting for Xcode CLT install to complete..."
    until xcode-select -p &>/dev/null; do sleep 5; done
    ok "Xcode CLT installed."
fi

# --- 2. Homebrew ---
if command -v brew &>/dev/null; then
    ok "Homebrew already installed."
else
    info "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ok "Homebrew installed."
fi

# Add brew to PATH for this session (Apple Silicon path)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# --- 3. Clone mac-setup ---
if [ -d "$REPO_DIR/.git" ]; then
    ok "mac-setup repo already present at $REPO_DIR."
else
    info "Cloning mac-setup to $REPO_DIR..."
    mkdir -p "$HOME/dev"
    git clone "$REPO_URL" "$REPO_DIR"
    ok "mac-setup cloned."
fi

# --- 4. Run unattended setup ---
cd "$REPO_DIR"
info "Running ./setup.sh..."
./setup.sh

# --- 5. Next steps ---
cat <<EOF

${GREEN}=== Bootstrap complete ===${NC}

Next steps (manual):
  1. cd $REPO_DIR
  2. ./setup-interactive.sh   # changes default shell to zsh, gh auth, etc.
  3. Restart terminal.
  4. Launch each GUI app once to grant permissions (Raycast, Aerospace, Karabiner, etc.)
  5. Sign into apps manually (Chrome, Slack, Obsidian sync, etc.)
  6. Log out + back in to fully apply macOS defaults (keyboard repeat, reduced motion).

EOF
