# PRD: macOS Setup Automation

## 1. Background

The current process for setting up a new macOS machine relies on Ansible. While powerful, Ansible can be complex to maintain for this use case. The goal is to migrate to a simpler, more transparent, and developer-friendly solution using plain shell scripts. This new system should be robust, easy to extend, and provide a great user experience for setting up a new development environment quickly and reliably.

## 2. Goals

- **Simplicity & Readability**: The entire system should be easy to understand and maintain. Scripts should be well-structured and clear.
- **Modularity & Extensibility**: The architecture must be "plug-and-play," allowing new setup components (e.g., installing a new app, configuring a tool) to be added with minimal effort.
- **Idempotency**: Running the setup script multiple times should not cause errors or unintended side-effects. The script will check for existing installations and configurations and skip them unless explicitly forced.
- **Testability**: The system must be testable to ensure reliability and prevent regressions as new modules are added.
- **Informative Output**: Provide clear logging to the user about what is happening, what succeeded, and what failed.
- **Configuration Management**: A simple mechanism to manage user-specific configurations or secrets should be included.
- **Unattended Automation**: Maximize the number of setup steps that can be run without user interaction, to enable "one-click" or CI-based setup.

## 3. Non-Goals

- A graphical user interface (GUI). This will remain a command-line tool.
- Support for operating systems other than macOS.
- Complex dependency resolution between modules beyond simple execution ordering.
- A sophisticated `--help` or `--list` command-line interface. Functionality will be documented in the `README.md`.

## 4. Personas

- **Primary User**: A developer who wants to quickly set up a new MacBook for development work. They are comfortable with the command line and want a reliable, automated process.

## 5. User Stories

- As a developer, I want to run a single command to set up my entire machine so that I can get to work quickly.
- As a developer, I want the setup process to be idempotent so that I can re-run the script safely to install missing tools without re-installing everything.
- As a developer, I want to add a new application to my setup by creating a single, simple script.
- As a developer, I want to run only a specific part of the setup (e.g., just install tmux) to test it or reinstall a specific tool.
- As a developer, I want to see clear logs during the setup so I know what's happening and can debug issues easily.
- As a developer, I want to keep my personal API keys and settings separate from the main setup logic so that I don't commit secrets to version control.
- As a developer, I want the setup to run as unattended as possible, with any required interactive steps clearly separated and explained.
- As a developer, I want all my required Homebrew packages, casks, and taps to be installed as specified in the legacy Ansible `tasks/homebrew.yml`, and for the script to check against `brew list` to ensure nothing is missing. (Note: ngrok, alacritty, gimp, and imagemagick have been removed, and bat, fd, rg, and git-delta have been added to the new setup.)
- As a developer, I want the setup to install the Tmux Plugin Manager (TPM) if not already present.
- As a developer, I want the setup to install Oh-My-Zsh and the plugins zsh-fzf-history-search and evalcache if not already present.

## 6. System Architecture

The system is split into two phases to maximize unattended automation:

### Phase 1: Unattended Setup
- **Script:** `setup.sh` (or `setup-unattended.sh`)
- **Purpose:** Runs all non-interactive, idempotent modules (e.g., Homebrew install, package installs, config file setup).
- **Behavior:** Skips or defers any step that requires user input (e.g., changing the default shell, SSH key generation).
- **Outcome:** Can be run unattended, in CI, or as a "one-click" setup.

### Phase 2: Interactive Setup
- **Script:** `setup-interactive.sh`
- **Purpose:** Handles all steps that require user input or authentication (e.g., changing the default shell, manual dotfile symlinks, SSH key prompts).
- **Behavior:** Prints clear instructions and warnings for each interactive step. Can be run after the unattended script, or whenever the user is ready.

### Directory Structure

```
mac-setup/
├── setup.sh                # Main unattended setup script
├── setup-interactive.sh    # Interactive steps script
├── README.md               # Documentation
├── config.sh.example       # Example configuration file
├── config.sh               # User-specific config (git-ignored)
├── modules/                # Directory for individual setup scripts (plugins)
│   ├── 00_homebrew.sh      # The '00_' prefix controls execution order
│   ├── 10_zsh.sh           # Zsh install, Oh-My-Zsh, plugins (no chsh)
│   └── 20_tmux.sh          # Tmux and TPM
├── lib/                    # Utility scripts and helper functions
│   └── utils.sh            # For logging, checks, etc.
└── tests/                  # For testing the scripts
    ├── test_runner.sh
    └── bats/               # bats-core testing framework
```

### Components:

- **`setup.sh`**: The main entry point for unattended setup. Executes all non-interactive modules.
- **`setup-interactive.sh`**: Handles all interactive steps, such as changing the default shell or generating SSH keys.
- **`modules/`**: Contains the "feature" scripts. Each script is responsible for one piece of the setup (e.g., installing Homebrew, configuring git, installing TPM, Oh-My-Zsh, and plugins). They are self-contained but can use functions from `utils.sh`.
- **`lib/utils.sh`**: A library of shared shell functions for logging (`log_info`, `log_success`, `log_error`), running commands, and checking for the existence of tools.
- **`config.sh`**: A user-provided file for secrets and personal configuration, which will be ignored by git. An accompanying `config.sh.example` will document the available options.
- **`tests/`**: Contains tests for the modules, written using the `bats-core` testing framework.

## 7. Functional Requirements

| ID | Requirement | Details |
|----|---|---|
| 1  | **Orchestration** | The `setup.sh` script will execute all `.sh` files in the `modules/` directory alphabetically, skipping interactive steps. |
| 2  | **Selective Execution** | The user can run specific modules by passing their names as arguments. Ex: `./setup.sh tmux zsh` will only run `20_tmux.sh` and `10_zsh.sh`. If no arguments are given, all modules run. |
| 3  | **Idempotency** | Each module must check if its task has already been completed (e.g., app installed, config applied) and skip itself if so. |
| 4  | **Force Execution** | A `--force` flag can be passed to a module to make it run even if it would normally be skipped. Ex: `./setup.sh --force tmux`. |
| 5  | **Logging** | The `lib/utils.sh` will provide colored logging functions: `log_info` (blue), `log_success` (green), `log_error` (red). |
| 6  | **Secret Management** | `setup.sh` will source a `config.sh` file if it exists, making environment variables available to all modules. |
| 7  | **Testing Framework** | The project will include `bats-core` for running automated tests on the modules. |
| 8  | **Documentation** | A `README.md` will explain the project's purpose, usage (including selective execution), and how to create new modules. |
| 9  | **Dry Run Mode** | A `--dry-run` flag will print the actions that would be taken without actually executing them. |
| 10 | **Interactive Steps** | All steps requiring user input (e.g., `chsh`, SSH key generation) are deferred to `setup-interactive.sh` and clearly documented. |
| 11 | **Homebrew Package Coverage** | The Homebrew module/script must install all apps, casks, and taps listed in the legacy `tasks/homebrew.yml`, and compare against the output of `brew list` to ensure all required packages are installed. The script must be idempotent and ensure no required package is missing. (Note: ngrok, alacritty, gimp, and imagemagick have been removed, and bat, fd, rg, and git-delta have been added to the new setup.) |
| 12 | **Tmux Plugin Manager** | The setup must install the Tmux Plugin Manager (TPM) by cloning https://github.com/tmux-plugins/tpm into ~/.tmux/plugins/tpm if not already present. |
| 13 | **Zsh Plugins and Oh-My-Zsh** | The setup must install Oh-My-Zsh if not present, and install the plugins zsh-fzf-history-search and evalcache into ~/.oh-my-zsh/plugins if not present. Optionally, check for /opt/homebrew/bin/zsh and document as a note. Changing the default shell is handled in the interactive script. |

--- 