#!/usr/bin/env bash

# Main orchestrator script for mac-setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set up log directory and log file
LOG_DIR="$SCRIPT_DIR/log"
mkdir -p "$LOG_DIR"

# Determine type of execution for log file name
if [ $# -eq 0 ]; then
  EXEC_TYPE="full"
else
  EXEC_TYPE="${1}"
fi
LOG_TIMESTAMP="$(date '+%Y-%m-%d-%H%M%S')"
LOG_FILE="$LOG_DIR/${LOG_TIMESTAMP}-${EXEC_TYPE}.log"

# Try to create the log file
if ! touch "$LOG_FILE" 2>/dev/null; then
  echo "[ERROR] Failed to create log file: $LOG_FILE" >&2
  exit 1
fi

# Export log file path for use in logging functions
export MAC_SETUP_LOG_FILE="$LOG_FILE"

# Source utility functions
source "$SCRIPT_DIR/lib/utils.sh"

# Trap errors and abnormal exits to log them
trap 'log_error "Script terminated unexpectedly (exit code $?)"' ERR
trap 'log_info "Setup script exited (exit code $?)"' EXIT

# Source user config if it exists
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
  log_info "Loaded user config from config.sh"
fi

# Parse arguments for selective module execution and dry-run
DRY_RUN=false
SELECTED_MODULES=()
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    DRY_RUN=true
  else
    SELECTED_MODULES+=("$arg")
  fi
done

# Discover all .sh modules in the modules directory (sorted)
MODULES_DIR="$SCRIPT_DIR/modules"
MODULE_SCRIPTS=( )
if [ -d "$MODULES_DIR" ]; then
  while IFS= read -r -d '' file; do
    MODULE_SCRIPTS+=("$file")
  done < <(find "$MODULES_DIR" -type f -name '*.sh' -print0 | sort -z)
  log_info "Discovered ${#MODULE_SCRIPTS[@]} module(s) in $MODULES_DIR."
else
  log_error "Modules directory not found: $MODULES_DIR"
fi

# Filter modules if arguments are provided
if [ ${#SELECTED_MODULES[@]} -gt 0 ]; then
  FILTERED_MODULES=()
  for module in "${MODULE_SCRIPTS[@]}"; do
    base="$(basename "$module" .sh)"
    # Remove numeric prefix and underscore, e.g., 00_homebrew -> homebrew
    name="${base#[0-9][0-9]_}"
    for sel in "${SELECTED_MODULES[@]}"; do
      if [[ "$name" == "$sel" ]]; then
        FILTERED_MODULES+=("$module")
      fi
    done
  done
  MODULE_SCRIPTS=("${FILTERED_MODULES[@]}")
  log_info "Filtered to ${#MODULE_SCRIPTS[@]} selected module(s)."
fi

# Dry run: print what would be executed
if [ "$DRY_RUN" = true ]; then
  log_info "Dry run mode: the following modules would be executed:"
  for module in "${MODULE_SCRIPTS[@]}"; do
    echo "  - $(basename "$module")"
  done
  exit 0
fi

# Execute each module script in order
for module in "${MODULE_SCRIPTS[@]}"; do
  log_info "Running module: $(basename "$module")"
  if bash "$module"; then
    log_success "Module succeeded: $(basename "$module")"
  else
    log_error "Module failed: $(basename "$module")"
    exit 1
  fi
  echo
done

# Further logic will be added in subsequent steps. 