#!/usr/bin/env bash

# Install agency-agents for Claude Code
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

AGENTS_DIR="$HOME/.claude/agents"
REPO_URL="https://github.com/msitarzewski/agency-agents.git"
TMP_DIR="$(mktemp -d)"

trap 'rm -rf "$TMP_DIR"' EXIT

log_info "Installing agency-agents into $AGENTS_DIR..."

mkdir -p "$AGENTS_DIR"

git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>/dev/null
if [ $? -ne 0 ]; then
    log_error "Failed to clone agency-agents."
    exit 1
fi

# Run the official convert + install scripts for Claude Code
cd "$TMP_DIR"
bash ./scripts/convert.sh >/dev/null 2>&1
bash ./scripts/install.sh --tool claude --no-interactive >/dev/null 2>&1

if [ $? -ne 0 ]; then
    log_error "agency-agents install script failed."
    exit 1
fi

log_success "agency-agents installed to $AGENTS_DIR."
