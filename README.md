# mac-setup: Modular macOS Development Environment Setup

## Overview

**mac-setup** is a modular, idempotent, and developer-friendly system for automating the setup of a macOS development environment. It replaces complex Ansible playbooks with simple, extensible shell scripts. The system is split into unattended and interactive phases for maximum automation and clarity.

- **Unattended setup:** Installs all tools and configures your system with no user interaction required.
- **Interactive setup:** Handles steps that require user input (e.g., changing your default shell, SSH key generation).
- **Modular:** Each feature (Homebrew, Zsh, Tmux, etc.) is a self-contained script.
- **Idempotent:** Safe to re-run; only missing items are installed/configured.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Xcode Command Line Tools](#xcode-command-line-tools)
- [Configuration](#configuration)
- [How Modules Work](#how-modules-work)
- [Homebrew Packages Managed](#homebrew-packages-managed)
- [Yabai Setup](#yabai-setup-tiling-window-manager)
- [Dotfiles and Neovim Configuration](#dotfiles-and-neovim-configuration)
- [Zsh and Tmux Plugin Management](#zsh-and-tmux-plugin-management)
- [Developer Guide](#developer-guide)
- [Tart](#tart-vms-on-apple-silicon)
- [Troubleshooting & FAQ](#troubleshooting--faq)

---

## Quick Start

1. **Clone the repository:**

   ```bash
   git clone https://github.com/tomerlevy1/mac-setup.git && cd mac-setup
   ```

2. **(Optional) Copy and edit your config:**

   ```bash
   cp config.sh.example config.sh
   # Edit config.sh to set any personal variables
   ```

3. **Run the unattended setup:**

   ```bash
   ./setup.sh
   # Or run specific modules:
   ./setup.sh zsh tmux
   # Use --dry-run to preview actions:
   ./setup.sh --dry-run
   ```

4. **Run the interactive setup (for user-input steps):**
   ```bash
   ./setup-interactive.sh
   ```

---

## Xcode Command Line Tools

- **Required for Homebrew and many development tools.**
- The setup will check for Xcode Command Line Tools and trigger installation if missing.
- **Updating:** macOS does not provide a direct CLI update for these tools. To update, use **Software Update** or reinstall manually if needed.
- If you see a warning about updating, follow the instructions in System Preferences > Software Update.

---

## Configuration

- **config.sh.example:** Shows all available configuration variables. Copy to `config.sh` and edit as needed.
- **config.sh:** Is sourced by all modules if present. Use it for secrets, tokens, or personal settings. This file is git-ignored.

---

## How Modules Work

- All setup logic is in `modules/` as numbered scripts (e.g., `00_homebrew.sh`, `10_zsh.sh`).
- Each module is:
  - **Idempotent:** Checks if its task is already done before acting.
  - **Self-contained:** Uses utilities from `lib/utils.sh` for logging and command checks.
- To add a new module:
  1. Create a new script in `modules/` (e.g., `30_mytool.sh`).
  2. Use the logging and helper functions from `lib/utils.sh`.
  3. Ensure your script is idempotent.
  4. Document any interactive steps and move them to `setup-interactive.sh` if needed.

---

## Homebrew Packages Managed

- **Taps:**
  - homebrew/cask-fonts
  - koekeishiya/formulae
  - FelixKratz/formulae
  - espanso/espanso
- **Casks:**
  - font-jetbrains-mono-nerd-font
  - maccy
  - karabiner-elements
  - ghostty
- **Formulae:**
  - bat, commitizen, espanso, eza, fd, fnm, fzf, gh, git, git-delta, jq, lazygit, less, neovim, ripgrep, sketchybar, skhd, starship, stow, tldr, tmux, tree, yabai, yq, zoxide, zsh, zsh-autosuggestions, zsh-history-substring-search, zsh-syntax-highlighting, **tart**

---

## Yabai Setup (Tiling Window Manager)

[yabai](https://github.com/koekeishiya/yabai) is a powerful tiling window manager for macOS. It is installed automatically, but **manual steps are required** for full functionality:

- **Accessibility API:**
  - Grant yabai access in System Settings > Security & Privacy > Accessibility.
- **Screen Recording:**
  - Grant yabai permission if you want window animations (System Settings > Security & Privacy > Screen Recording).
- **System Integrity Protection (SIP):**
  - Some advanced features require partially disabling SIP. See the [yabai wiki](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection) for details. This is optional but recommended for power users.
- **Code Signing:**
  - If building from source or using advanced features, you may need to code sign the binary. See the [yabai documentation](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)) for instructions.
- **System Settings:**
  - Ensure "Displays have separate Spaces" is enabled in Mission Control (System Settings > Desktop & Dock > Mission Control).
  - Disable "Automatically rearrange Spaces based on most recent use" for reliable space management.

For more, see the [official yabai documentation](https://github.com/koekeishiya/yabai).

---

## Dotfiles and Neovim Configuration

- The setup will automatically clone your dotfiles from [tomerlevy1/.dotfiles](https://github.com/tomerlevy1/.dotfiles) to `~/.dotfiles`.
- Your Neovim configuration will be cloned from [tomerlevy1/nvim](https://github.com/tomerlevy1/nvim) to `~/.config/nvim`.

---

## Zsh and Tmux Plugin Management

- **Zsh:**
  - Installs [Oh-My-Zsh](https://ohmyz.sh/) if not present.
  - Installs plugins:
    - [zsh-fzf-history-search](https://github.com/joshskidmore/zsh-fzf-history-search)
    - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
    - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - Warns if `/opt/homebrew/bin/zsh` is not found (required for Homebrew Zsh).
- **Tmux:**
  - Installs [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm) if not present.

---

## Developer Guide

- **Add a new module:**
  - Place a new script in `modules/`.
  - Use `log_info`, `log_success`, `log_error`, and `command_exists` from `lib/utils.sh`.
  - Make your script idempotent.
  - If your step requires user input, move it to `setup-interactive.sh`.
- **Testing:**
  - Automated testing with BATS is planned for future implementation.
  - Test modules individually by running `./setup.sh <module>`.
  - Manual testing using tart (see Tart section below).

---

## Tart (VMs on Apple Silicon)

- [Tart](https://github.com/cirruslabs/tart) is a virtualization toolset to build, run, and manage macOS and Linux VMs on Apple Silicon. It uses Apple's Virtualization.Framework for near-native performance and is ideal for CI and automation workflows.
- **Manual test:**
  1. Install Tart:
     ```sh
     brew install cirruslabs/cli/tart
     ```
  2. To try running a VM (downloads a big image):
     ```sh
     tart clone ghcr.io/cirruslabs/macos-sequoia-base:latest sequoia-base
     tart run sequoia-base
     ```
  3. For more info, see the [official documentation](https://github.com/cirruslabs/tart).

---

## Troubleshooting & FAQ

- **Q: Can I re-run the setup?**
  - A: Yes! All scripts are idempotent and safe to re-run.
- **Q: How do I add my own secrets or tokens?**
  - A: Add them to `config.sh` (never commit this file).
- **Q: What if a tool is already installed?**
  - A: The script will skip it and log a success message.
- **Q: How do I add a new tool or step?**
  - A: Add a new module script in `modules/` and follow the developer guide above.

