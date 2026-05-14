# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular, idempotent macOS development environment setup system using shell scripts. It replaces Ansible playbooks with simple, extensible bash scripts split into unattended and interactive phases.

## Repository Visibility

**This repo is PUBLIC** (`github.com/tomerlevy1/mac-setup`). Treat every change as
world-readable forever. Before committing or pushing:

- Never commit secrets, tokens, API keys, SSH keys, passwords, or credentials. Anything sensitive
  belongs in `config.sh` (gitignored) or an external secret store.
- Never commit personal/work email addresses, internal hostnames, internal URLs, employer-internal
  tooling names, client names, or other PII beyond what's already public in this repo.
- Never reference private repos by URL in a way that exposes private project names or paths
  (the existing `tomerlevy1/.dotfiles`, `tomerlevy1/nvim`, `tomerlevy1/nvim12` references are
  already public via this repo — fine to keep, but don't add new ones casually).
- Logs in `log/` may contain machine-specific paths or env values — they're gitignored, keep it
  that way.
- Before staging, scan the diff for the above. If anything sensitive shows up, stop and flag it
  to the user rather than committing.

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
