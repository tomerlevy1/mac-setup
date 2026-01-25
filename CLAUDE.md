# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular, idempotent macOS development environment setup system using shell scripts. It replaces Ansible playbooks with simple, extensible bash scripts split into unattended and interactive phases.

## Commands

```bash
# Run full unattended setup (all modules)
./setup.sh

# Run specific modules by name (without numeric prefix)
./setup.sh homebrew zsh tmux

# Preview what would run without executing
./setup.sh --dry-run

# Run interactive setup (shell change, gh auth)
./setup-interactive.sh
```

## Architecture

**Entry Points:**
- `setup.sh` - Main orchestrator that discovers and runs modules in sorted order
- `setup-interactive.sh` - Handles steps requiring user input (shell change, GitHub auth)

**Module System:**
- Modules live in `modules/` with numeric prefixes for ordering (e.g., `00_homebrew.sh`, `10_zsh.sh`)
- Each module sources `lib/utils.sh` for logging and helpers
- Modules must be idempotent - they check state before acting
- Module name extraction: `00_homebrew.sh` → `homebrew` (for CLI selection)

**Shared Utilities (`lib/utils.sh`):**
- `log_info`, `log_success`, `log_warn`, `log_error` - Colored console output + file logging
- `command_exists` - Check if command is available
- Logs written to `log/` directory with timestamps

**Configuration:**
- `config.sh.example` - Template for user config
- `config.sh` - User's personal config (gitignored), sourced by all modules

## Adding New Modules

1. Create `modules/NN_name.sh` (NN = numeric order)
2. Source utils: `source "$SCRIPT_DIR/lib/utils.sh"`
3. Make it idempotent (check before installing)
4. Move any interactive steps to `setup-interactive.sh`

## Homebrew Management

The `00_homebrew.sh` module manages three arrays:
- `TAPS` - Homebrew tap repositories
- `CASKS` - GUI applications
- `FORMULAE` - CLI tools

The module compares installed vs required packages and reports discrepancies.
