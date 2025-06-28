# Context Map: mac-setup Directory

## Purpose

The `mac-setup` directory contains scripts and supporting files to automate the setup of a macOS development environment. It is designed for reproducibility, modularity, and ease of debugging, with robust logging and clear separation of concerns.

## Directory Structure

- `mac-setup/`
  - `modules/` — Individual setup modules (e.g., Homebrew, Zsh, Tmux, dotfiles, etc.). Each module is a standalone shell script.
  - `lib/utils.sh` — Shared utility functions, including logging, color output, and command checks.
  - `setup.sh` — Main unattended setup orchestrator. Runs all or selected modules in order.
  - `setup-interactive.sh` — Interactive setup script for steps requiring user input.
  - `log/` — Directory for plain text log files, one per run, with unique names.
  - `README.md` — Documentation and usage instructions.
  - `config.sh.example` — Example user config file (ignored by git).

## Logging Implementation

- All terminal log output (info, warn, success, error) is also written to a plain text log file for each run.
- Log files are stored in `mac-setup/log/` and named as `YYYY-MM-DD-HHMMSS-[TYPE_OF_EXECUTION].log`.
- Log entries follow the format: `YYYY-MM-DD HH:MM:SS [LEVEL] [context] message` (e.g., `2024-06-07 15:30:12 [INFO] [setup.sh] Homebrew installed successfully`).
- The context/module name can be set via the `LOG_CONTEXT` environment variable (defaults to `setup.sh`).
- If the log file cannot be created, the script fails immediately.
- Logging is required for the unattended setup script; interactive script support is optional/future.

## Key Conventions

- All modules source `lib/utils.sh` for logging and utility functions.
- Each module should be idempotent and safe to re-run.
- Direct `echo` statements for user-facing output should be replaced with logging functions where possible.
- The main setup script (`setup.sh`) supports selective module execution via arguments.
- Error handling is robust: traps are set for `ERR` and `EXIT` to ensure all script terminations are logged.

## Migration/Reuse Instructions

- When copying `mac-setup` to a new repository:
  - Ensure the `log/` directory is present or will be created by the script.
  - Update the `LOG_CONTEXT` variable in each script if you want more granular context in logs.
  - Review `.gitignore` to ensure log files and user configs are not committed.
  - Update documentation as needed for your new environment or requirements.
- All implementation details and conventions are documented in this file and in the PRD/task files under `tasks/`.

## References

- See `tasks/prd-logging.md` for the product requirements for logging.
- See `tasks/tasks-prd-logging.md` for the implementation task breakdown.
- See `mac-setup/README.md` for usage and developer instructions. 