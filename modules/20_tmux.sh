#!/usr/bin/env bash

# tmux installation and configuration module
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Ensure tmux is installed
if command_exists tmux; then
  log_success "tmux is already installed."
else
  log_info "Installing tmux..."
  if command_exists brew; then
    brew install tmux
  else
    log_error "Homebrew is not installed. Cannot install tmux."
    exit 1
  fi
  if command_exists tmux; then
    log_success "tmux installation successful."
  else
    log_error "tmux installation failed."
    exit 1
  fi
fi

# Install TPM (Tmux Plugin Manager) if not present
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  log_info "Installing TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  log_success "TPM installed."
else
  log_success "TPM is already installed."
fi

# Optionally, add configuration steps here (e.g., copy a default .tmux.conf)
# log_info "Configuring tmux..."
# cp "$SCRIPT_DIR/configs/tmux.conf" "$HOME/.tmux.conf" 