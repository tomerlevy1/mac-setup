#!/usr/bin/env bash

# Zsh installation module (non-interactive)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Ensure Zsh is installed
if ! command_exists zsh; then
  log_info "Installing Zsh..."
  if command_exists brew; then
    brew install zsh
  else
    log_error "Homebrew is not installed. Cannot install Zsh."
    exit 1
  fi
else
  log_success "Zsh is already installed."
fi 

# Warn if /opt/homebrew/bin/zsh is not found
if [ ! -x "/opt/homebrew/bin/zsh" ]; then
  log_error "/opt/homebrew/bin/zsh not found. If you installed Zsh via Homebrew, ensure it is correctly linked."
else
  log_info "/opt/homebrew/bin/zsh is present."
fi

# Install Oh-My-Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log_info "Installing Oh-My-Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  log_success "Oh-My-Zsh installed."
else
  log_success "Oh-My-Zsh is already installed."
fi

# Install zsh-fzf-history-search plugin if not present
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-fzf-history-search" ]; then
  log_info "Installing zsh-fzf-history-search plugin..."
  git clone https://github.com/joshskidmore/zsh-fzf-history-search.git "$HOME/.oh-my-zsh/plugins/zsh-fzf-history-search"
  log_success "zsh-fzf-history-search plugin installed."
else
  log_success "zsh-fzf-history-search plugin is already installed."
fi

# Install zsh-syntax-highlighting plugin if not present
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
  log_info "Installing zsh-syntax-highlighting plugin..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"
  log_success "zsh-syntax-highlighting plugin installed."
else
  log_success "zsh-syntax-highlighting plugin is already installed."
fi

# Install zsh-autosuggestions plugin if not present
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
  log_info "Installing zsh-autosuggestions plugin..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
  log_success "zsh-autosuggestions plugin installed."
else
  log_success "zsh-autosuggestions plugin is already installed."
fi

# Note: No logic for git, z, docker, npm, brew, or evalcache plugins as per user request. 