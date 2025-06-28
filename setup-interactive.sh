#!/usr/bin/env bash

# Interactive setup script for mac-setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

log_info "Starting interactive setup..."

# Interactive Zsh default shell change
if command_exists zsh; then
  CURRENT_SHELL=$(dscl . -read ~ UserShell | awk '{print $2}')
  ZSH_PATH="$(command -v zsh)"
  if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
    echo
    log_info "You are about to change your default shell to Zsh."
    echo "This will require your user password (not your Apple ID or root password)."
    echo "After this step, you should restart your terminal to use Zsh as your default shell."
    read -p "Press Enter to continue or Ctrl+C to abort..."
    if ! grep -q "$ZSH_PATH" /etc/shells; then
      log_info "Adding $ZSH_PATH to /etc/shells (requires sudo)..."
      echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$ZSH_PATH"
    log_success "Default shell changed to Zsh. Please restart your terminal."
  else
    log_success "Zsh is already your default shell."
  fi
else
  log_error "Zsh is not installed. Please run the unattended setup first."
  exit 1
fi

# GitHub CLI authentication
if command_exists gh; then
  if ! gh auth status &>/dev/null; then
    echo
    log_info "GitHub CLI (gh) is installed but not authenticated."
    read -p "Would you like to run 'gh auth login' now? [Y/n] " yn
    case $yn in
      [Nn]*) log_warn "Skipping GitHub authentication." ;;
      *)
        log_info "Launching 'gh auth login'..."
        gh auth login
        if [ $? -eq 0 ]; then
          log_success "GitHub CLI authenticated successfully."
        else
          log_error "GitHub CLI authentication failed."
        fi
        ;;
    esac
  else
    log_success "GitHub CLI is already authenticated."
  fi
else
  log_warn "GitHub CLI (gh) is not installed. Please run the unattended setup first."
fi

echo
log_info "Interactive setup complete. If you changed your shell, please restart your terminal."
# Add more interactive steps here as needed (e.g., SSH key generation) 