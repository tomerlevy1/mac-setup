# PRD: Plain Text Logging for Setup Runs

## Introduction/Overview

This feature introduces a plain text logging mechanism for the macOS setup automation scripts. The goal is to ensure that every message printed to the terminal (info, warn, success, error) is also captured in a human-readable log file for each run. This will aid in debugging and provide a persistent record of what occurred during each execution, especially in the event of failures.

## Goals

- Capture all terminal log output (info, warn, success, error) in a plain text file for every run.
- Ensure the log file is always created, even if the script fails partway through.
- Store all log files in a dedicated log directory with unique, timestamped filenames.
- Make the log format easy for a human to read, consistent, and easy to parse.
- Fail the script if the log file cannot be created.

## User Stories

- As a developer, I want every message printed to the terminal during a setup run to also be saved in a log file, so that I can debug issues after the fact.
- As a developer, I want each run to have its own uniquely named log file, so I can easily distinguish between different executions and review their outputs.
- As a developer, I want each log entry to include a timestamp and log level, so I can trace the sequence and timing of events.

## Functional Requirements

1. The system must create a dedicated `log` directory (if it does not exist) to store all log files.
2. The system must generate a unique log file name for each run using the format: `YYYY-MM-DD-HHMMSS-[TYPE_OF_EXECUTION].log` (e.g., `2024-06-07-153012-full.log` or `2024-06-07-153012-tmux.log`).
3. The system must write every log message (info, warn, success, error) printed to the terminal to the log file, in the format: `YYYY-MM-DD HH:MM:SS [LEVEL] message` (e.g., `2024-06-07 15:30:12 [INFO] Homebrew installed successfully`).
4. Optionally, the log entry may include the module/context (e.g., `[setup.sh]`).
5. The log file must not contain any color codes or terminal formatting.
6. The log file must be created at the start of the run, and logging must continue even if the script fails partway.
7. If the log file cannot be created, the script must fail immediately with an appropriate error message.
8. (Phase 1) Logging is required for the unattended setup script only. (If supporting the interactive script is trivial, it may be included.)

## Non-Goals (Out of Scope)

- No requirement to log timestamps for each message in the terminal (only in the log file).
- No requirement to support JSON, CSV, or other machine-readable log formats.
- No requirement to rotate or delete old log files automatically.
- No requirement to log every shell command executed (only the messages printed to the terminal).

## Design Considerations

- The log directory should be created alongside the setup scripts (e.g., `mac-setup/log/`).
- The logging mechanism should be implemented in a way that is easy to extend to other scripts/modules in the future.
- The log file name should include both a timestamp and the type of execution (e.g., full run or specific module).
- The log file format should follow best practices: include timestamps, use brackets for log levels, and optionally include context/module.
- The log file should be easy to parse with tools like `awk`, `grep`, or import into spreadsheets.

## Technical Considerations

- The logging functions in `utils.sh` may need to be updated to support dual output (terminal and log file) and to format log entries as specified.
- The script should check for write permissions before starting the run.
- The log file should be opened for appending at the start of the script and closed at the end (if necessary).

## Success Metrics

- Every run of the unattended setup script produces a log file in the correct format and location.
- The log file contains all terminal output messages, formatted as specified, with no color codes and with timestamps and log levels.
- The script fails gracefully if the log file cannot be created.

## Open Questions

- Should the log directory location be configurable via an environment variable or config file?
- Should there be an option to disable logging if not needed? 