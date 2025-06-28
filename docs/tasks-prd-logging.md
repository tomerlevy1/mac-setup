## Relevant Files

- `mac-setup/lib/utils.sh` – Update logging functions to support dual output (terminal and log file, no color codes in file, improved format).
- `mac-setup/setup.sh` – Initialize logging, ensure all output is captured, handle log file creation and errors.
- `mac-setup/log/` – Directory to store all generated log files.

### Notes

- All log files should be stored in `mac-setup/log/`.
- The log file name should use the format `YYYY-MM-DD-HHMMSS-[TYPE_OF_EXECUTION].log`.
- If the log file cannot be created, the script should fail immediately.
- Logging is required for the unattended setup script only in this phase.
- **Log file entries must include:**
  - Timestamp (`YYYY-MM-DD HH:MM:SS`)
  - Bracketed log level (e.g., `[INFO]`, `[ERROR]`)
  - The log message
  - (Optional) Context/module name (e.g., `[setup.sh]`)
- The log file must be easy to parse and consistent for future tooling.

## Tasks

- [x] 1.0 Create and manage the log directory and log file
  - [x] 1.1 Ensure the `mac-setup/log/` directory exists; create it if missing.
  - [x] 1.2 Generate a unique log file name using the format `YYYY-MM-DD-HHMMSS-[TYPE_OF_EXECUTION].log`.
  - [x] 1.3 Attempt to create the log file at the start of the run; fail with an error if not possible.
  - [x] 1.4 Store the log file path in a variable accessible to logging functions.

- [x] 2.0 Update logging functions in `utils.sh` to support writing to both terminal and log file (without color codes)
  - [x] 2.1 Refactor `log_info`, `log_warn`, `log_success`, and `log_error` to accept a log file path as an argument or use a global variable.
  - [x] 2.2 Ensure each function writes the message to the terminal (with color) and to the log file (plain text, no color codes).
  - [x] 2.3 Format each log entry as `TYPE_OF_LOG message` in the log file.
  - [x] 2.4 Add error handling to logging functions in case writing to the log file fails during execution.

- [ ] 3.0 Improve log file format for best practices
  - [ ] 3.1 Add timestamps to each log entry in the log file (`YYYY-MM-DD HH:MM:SS`).
  - [ ] 3.2 Use brackets for log levels (e.g., `[INFO]`, `[ERROR]`).
  - [ ] 3.3 Optionally include context/module name in log entries.
  - [ ] 3.4 Ensure the log file is consistent and easy to parse (e.g., space or pipe separated fields).
  - [ ] 3.5 Update tests and documentation to reflect the new log format.

- [x] 4.0 Ensure robust error handling and log file creation on failures
  - [x] 4.1 Ensure the log file is created even if the script fails partway through (e.g., use `trap` to handle errors and log them).
  - [x] 4.2 Log any errors or abnormal terminations to the log file before exiting.
  - [x] 4.3 Test failure scenarios to confirm the log file is always created and contains relevant output.

- [ ] 5.0 (Optional/Stretch) Prepare for future extension to interactive setup script
  - [ ] 5.1 Review `setup-interactive.sh` to assess effort required for similar logging integration.
  - [ ] 5.2 Document any changes needed to support logging in the interactive script in the future.

---

### Suggested Conventional Commit Messages

- feat(setup): create and manage log directory and unique log file for each run
- feat(utils): refactor logging functions for dual output to terminal and log file
- feat(logging): improve log file format with timestamps, bracketed log levels, and optional context
- feat(setup): integrate new logging into setup.sh and replace direct output with logging functions
- feat(setup): add robust error handling and ensure log file creation on failures 