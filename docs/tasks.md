# Project Tasks: macOS Setup Automation

## Main Tasks

1. **Initialize Project Structure** [x]
    1.1. [x] Create the root directory `mac-setup`.
    1.2. [x] Create subdirectories: `mac-setup/modules`, `mac-setup/lib`, `mac-setup/tests`.
    1.3. [x] Create an initial `.gitignore` file in `mac-setup` to ignore `config.sh` and other local development files.

2. **Implement Core Utilities** [x]
    2.1. [x] Create `mac-setup/lib/utils.sh`.
    2.2. [x] Add colored logging functions (`log_info`, `log_success`, `log_error`) to `utils.sh`.
    2.3. [x] Add a helper function to check for the existence of a command (e.g., `command_exists`).

3. **Develop the Main Orchestrator Script** [x]
    3.1. [x] Create the main script `mac-setup/setup.sh` (unattended setup).
    3.2. [x] Implement logic in `setup.sh` to source `lib/utils.sh`.
    3.3. [x] Add logic to source `mac-setup/config.sh` if it exists.
    3.4. [x] Implement module discovery to find all `.sh` files in the `modules/` directory.
    3.5. [x] Implement the main loop in `setup.sh` to execute the discovered modules in alphabetical order.

4. **Implement Feature Flags** [x]
    4.1. [x] Add argument parsing to `setup.sh` for selective module execution (e.g., `./setup.sh tmux`).
    4.2. [x] Implement the `--dry-run` flag to show what commands would be executed.

5. **Migrate Ansible Roles to Modules** [x]
    5.1. [x] Create `mac-setup/modules/00_homebrew.sh` to handle Homebrew installation. This module should be idempotent.
    5.2. [x] Create `mac-setup/modules/10_zsh.sh` to install Zsh, Oh-My-Zsh, and plugins (idempotent, no chsh).
    5.3. [x] Create `mac-setup/modules/20_tmux.sh` to install and configure tmux and TPM (idempotent).
    5.4. [x] Ensure each module uses the logging and utility functions from `utils.sh`.
    5.5. [x] Refactor any interactive steps (e.g., chsh, SSH key generation) out of modules and into the interactive script.

6. **Update Homebrew Module for Full Coverage**
    6.1. [x] Parse the legacy `tasks/homebrew.yml` to extract all required formulae, casks, and taps. Remove ngrok, alacritty, gimp, and imagemagick from the lists. Add bat, fd, rg, and git-delta. Final lists are:
        - **Taps:** homebrew/cask-fonts, koekeishiya/formulae, FelixKratz/formulae, espanso/espanso
        - **Casks:** font-jetbrains-mono-nerd-font, maccy, karabiner-elements
        - **Formulae:** bat, commitizen, espanso, eza, fd, fnm, fzf, gh, git, git-delta, jq, lazygit, less, neovim, rg, ripgrep, sketchybar, skhd, starship, stow, tldr, tmux, tree, yabai, yq, z, zsh, zsh-autosuggestions, zsh-history-substring-search, zsh-syntax-highlighting
    6.2. [x] Update `mac-setup/modules/00_homebrew.sh` to install all required formulae, casks, and taps.
    6.3. [x] Implement logic to compare the required list against the output of `brew list` and `brew list --cask` to ensure completeness.
    6.4. [x] Ensure the script is idempotent and logs any missing or extra packages.
    6.5. [x] Test the updated script for idempotency and completeness.

7. **Set Up Configuration Management**
    7.1. [x] Create `mac-setup/config.sh.example` with commented-out examples of variables.

8. **Create Interactive Setup Script** [x]
    8.1. [x] Create `mac-setup/setup-interactive.sh` for all interactive steps (e.g., chsh, SSH key generation).
    8.2. [x] Add logic to perform interactive steps with clear user prompts and instructions.

9. **Create Documentation**
    9.1. [x] Create a comprehensive `mac-setup/README.md`.
    9.2. [x] Document the project's purpose, how to run the unattended and interactive setup scripts, and how to use features like selective execution and the `config.sh` file.
    9.3. [x] Add a guide for developers on how to create a new module and how to decide if a step belongs in the unattended or interactive script.

---

## New/Upcoming Tasks

10. **Create Git Configuration Module**
    10.1. [x] Create `mac-setup/modules/40_git.sh` to set all core global git configs (editor, pull, fetch, branch, default branch, credential helper, user/email from env vars).
    10.2. [x] Set global gitignore to `$HOME/.gitignore_global` if present, otherwise skip (warn if not found).

11. **Add GitHub CLI Installation**
    11.1. [x] Ensure `gh` is included in the Homebrew formulae in `00_homebrew.sh` (already present, but verify).

12. **Add GitHub Authentication to Interactive Script**
    12.1. [x] Add a step to `mac-setup/setup-interactive.sh` to run `gh auth login` if not already authenticated.

13. **Split Dotfiles Module into Submodules**
    13.1. [x] Create `mac-setup/modules/30_dotfiles-clone.sh` to clone the dotfiles repo if not present.
    13.2. [x] Create `mac-setup/modules/31_dotfiles-install.sh` to run `install.sh` from `.dotfiles` if present and executable.
    13.3. [x] Create `mac-setup/modules/32_nvim-config.sh` to clone Neovim config if not present.
    13.4. [x] Remove logic from `30_dotfiles.sh` and delete the file.

---

## Nice to Have

14. **Implement Testing**
    14.1. [ ] Add `bats-core` as a git submodule or download it into the `mac-setup/tests/` directory.
    14.2. [ ] Create a `mac-setup/tests/test_runner.sh` to execute all tests.
    14.3. [ ] Write a basic test file (e.g., `mac-setup/tests/test_tmux.sh`) to verify the `tmux` module's functionality.

15. **Final Cleanup**
    15.1. [ ] Remove all the old Ansible-related files and directories (`ansible_run`, `install_ansible`, `inventory`, `main.yml`, `tasks/`, `vars.yml`).
    15.2. [ ] Move the new `mac-setup` contents to the root of the project.
    15.3. [ ] Delete the `prd.md` and `generate-tasks.mdc` files.

16. **Implement the `--force` Flag**
    16.1. [ ] Implement the `--force` flag to allow re-running a module.

---

## Relevant Files

- `mac-setup/modules/40_git.sh`: Handles all core global git configuration and sets global gitignore if present.
- `mac-setup/modules/30_dotfiles-clone.sh`: Clones the dotfiles repo if not present.
- `mac-setup/modules/31_dotfiles-install.sh`: Runs `install.sh` from `.dotfiles` if present and executable.
- `mac-setup/modules/32_nvim-config.sh`: Clones Neovim config if not present.
- `mac-setup/setup-interactive.sh`: Script for running interactive steps, now includes GitHub authentication.
- `mac-setup/modules/00_homebrew.sh`: Installs Homebrew and all required formulae/casks/taps (verify `gh` is present).

---

## Suggested Conventional Commit Messages

- feat(setup): create root mac-setup directory
- feat(setup): add modules, lib, and tests subdirectories
- chore(setup): add initial .gitignore to mac-setup
- feat(utils): add utils.sh with logging and command_exists helpers
- feat(setup): create main setup.sh script
- feat(setup): source lib/utils.sh in setup.sh
- feat(setup): source config.sh if it exists in setup.sh
- feat(setup): discover modules in modules directory
- feat(setup): execute modules in main loop
- feat(setup): add selective module execution via arguments
- feat(setup): add --dry-run flag for module execution
- feat(modules): add idempotent Homebrew installation module
- feat(modules): add idempotent Zsh installation module (no chsh)
- feat(modules): add idempotent tmux installation module
- refactor(modules): ensure all modules use utils.sh for logging and checks
- refactor(setup): move interactive steps to setup-interactive.sh
- feat(setup-interactive): add clear prompts and instructions for interactive steps
- feat(homebrew): update Homebrew module to install all required formulae, casks, and taps
- feat(homebrew): compare installed vs required formulae and casks, log missing/extra
- chore(homebrew): add bat, fd, rg, and git-delta to required formulae
- feat(tmux): add TPM installation to tmux module
- feat(zsh): ensure only zsh-fzf-history-search, zsh-syntax-highlighting, and zsh-autosuggestions plugins are installed
- docs(zsh): warn if /opt/homebrew/bin/zsh is not found
- refactor(modules): ensure all modules are idempotent and skip if already installed

## New/Upcoming Tasks

- [x] 6.0 Replace Alacritty with Ghostty
  - [x] 6.1 Remove Alacritty from the Homebrew casks list in `00_homebrew.sh` (if present)
  - [x] 6.2 Add Ghostty to the Homebrew casks list: `brew install --cask ghostty`
  - [x] 6.3 Update documentation and package lists as needed

- [x] 7.0 Add new Homebrew casks
  - [x] 7.1 Use brew to install obsidian
  - [x] 7.2 Use brew to install chrome
  - [x] 7.3 Use brew to install mysqlworkbench 