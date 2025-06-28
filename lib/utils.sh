#!/usr/bin/env bash

# Color codes
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Optionally set context/module name for log entries
LOG_CONTEXT="${LOG_CONTEXT:-setup.sh}"

_log() {
  # $1 = type (info, success, warn, error)
  # $2 = color code
  # $3 = label (e.g., INFO, SUCCESS)
  # $4 = message
  # $5 = output stream (1 for stdout, 2 for stderr)
  local type="$1"
  local color="$2"
  local label="$3"
  local message="$4"
  local stream="$5"
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

  if [ "$stream" -eq 1 ]; then
    echo -e "${color}[${label}]${NC} $message"
  else
    echo -e "${color}[${label}]${NC} $message" >&2
  fi
  if [ -n "$MAC_SETUP_LOG_FILE" ]; then
    echo "$timestamp [${label}] [$LOG_CONTEXT] $message" >> "$MAC_SETUP_LOG_FILE" || { echo "[ERROR] Failed to write to log file: $MAC_SETUP_LOG_FILE" >&2; exit 1; }
  fi
}

log_info() {
  _log "info" "$BLUE" "INFO" "$1" 1
}

log_success() {
  _log "success" "$GREEN" "SUCCESS" "$1" 1
}

log_warn() {
  _log "warn" "$YELLOW" "WARN" "$1" 2
}

log_error() {
  _log "error" "$RED" "ERROR" "$1" 2
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
} 
