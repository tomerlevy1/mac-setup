#!/usr/bin/env bash

# Git configuration and setup module
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

log_info "Configuring global git settings..."

set_git_config() {
    local key="$1"
    local value="$2"
    if [ "$(git config --global --get "$key")" != "$value" ]; then
        git config --global "$key" "$value"
        log_success "Set $key to $value"
    else
        log_info "$key already set to $value"
    fi
}

# Core settings
set_git_config core.editor "nvim"
set_git_config pull.rebase "false"
set_git_config fetch.prune "true"
set_git_config branch.sort "-committerdate"
set_git_config init.defaultbranch "main"
set_git_config user.email $GIT_EMAIL
set_git_config user.name $GIT_NAME
set_git_config credential.helper "store"

if [ -f "$HOME/.gitignore_global" ]; then
    set_git_config core.excludesfile "$HOME/.gitignore_global"
    log_success "Set global gitignore to $HOME/.gitignore_global"
else
    log_warn "Global gitignore file $HOME/.gitignore_global not found. Skipping."
fi
