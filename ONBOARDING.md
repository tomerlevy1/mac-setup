# New Mac Onboarding

Lightspeed setup for a brand-new MacBook (Apple Silicon).

## TL;DR

On the new Mac, open Terminal and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomerlevy1/mac-setup/main/bootstrap.sh)"
```

Then:

```bash
cd ~/dev-personal/mac-setup && ./setup-interactive.sh
```

Restart the terminal. Done — rest of this doc covers permissions, sign-ins,
and sanity checks.

## 0. Apple onboarding

Finish Apple's first-boot flow: Apple ID sign-in, Wi-Fi, Touch ID, time zone.
Skip iCloud Drive Desktop/Documents sync — it conflicts with `~/dev`.

## 1. One-line bootstrap

Open the preinstalled **Terminal** app and paste:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomerlevy1/mac-setup/main/bootstrap.sh)"
```

This installs Xcode Command Line Tools, Homebrew, clones this repo to
`~/dev-personal/mac-setup`, and runs `./setup.sh` (all unattended modules).

Expect ~20–40 min depending on network. The Xcode CLT step shows a GUI
installer — accept it and the bootstrap script waits for it to finish.

## 2. Interactive setup

```bash
cd ~/dev-personal/mac-setup
./setup-interactive.sh
```

Handles:
- `chsh` to Homebrew zsh (asks for password)
- `gh auth login` (browser-based GitHub auth — opens Safari)
- `sudo ipconfig setverbose 1` (so sketchybar reads Wi-Fi SSID)

## 3. Restart terminal

Quit Ghostty/Terminal and reopen so the new shell + PATH load.

## 4. First-launch GUI permissions

Launch each once and grant prompts:

- **Raycast** — set hotkey, sign in
- **Aerospace** — Accessibility permission
- **Karabiner-Elements** — Input Monitoring + Accessibility
- **Ghostty** — pin to dock
- **Obsidian** — open vault from `~/vaults/notes`, configure sync
- **Maccy** — Accessibility, set hotkey
- **Claude Code** (cask) — sign in
- **Visual Studio Code** — sign in (Settings Sync)
- **NoTunes** — set as default music player
- **OrbStack** — start container engine
- **MySQL Workbench** — restore connections

## 5. Log out / restart

Required to fully apply:
- Keyboard repeat / initial delay
- Reduced motion / transparency
- Default shell change

## 6. Optional extras

Tools previously installed but not in the core setup live in
`EXTRA_FORMULAE` / `EXTRA_CASKS` arrays in `modules/00_homebrew.sh`. Install
on demand:

```bash
brew install <name>          # formula
brew install --cask <name>   # cask
```

## 6.5 Transfer from old Mac

Files NOT covered by any sync / repo — copy manually before wiping old Mac.

Easiest path: while both machines online, from **new Mac**:

```bash
# Replace OLD_MAC with the old Mac's hostname or IP (System Settings > Sharing)
OLD=tolevy@OLD_MAC.local

# Shell history
scp "$OLD:~/.zsh_history" ~/.zsh_history

# Non-GitHub SSH keys (webos_emul, OfficeTV_webos, etc.)
scp -r "$OLD:~/.ssh/" ~/.ssh-old-backup/
# Then manually merge wanted keys into ~/.ssh/ and set perms:
#   chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_* && chmod 644 ~/.ssh/*.pub

# AWS / cloud credentials (if used)
scp -r "$OLD:~/.aws" ~/.aws
scp -r "$OLD:~/.config/gcloud" ~/.config/gcloud 2>/dev/null

# Mise / fnm / language version files (if not in mise config)
# (already managed by mise in dotfiles — skip unless customized)

# Misc app data not in iCloud
scp -r "$OLD:~/Library/Application Support/Code/User/snippets" \
    "$HOME/Library/Application Support/Code/User/snippets" 2>/dev/null
```

Enable SSH access on old Mac first: **System Settings → General → Sharing →
Remote Login ON**.

Things that ARE synced (skip — will appear automatically):
- Obsidian vault (git)
- VS Code settings (Settings Sync)
- Chrome bookmarks/history (Google sync)
- Slack, Notion, Linear, etc. (cloud accounts)
- iCloud Desktop/Documents/Photos
- App Store apps (re-download)

## 7. Sanity checks

```bash
# Verify dotfiles symlinks point to dev-personal
readlink ~/.zshrc        # → dev-personal/.dotfiles/zsh/.zshrc

# Verify mise tools
mise ls

# Verify vault clone
ls ~/vaults/notes

# Verify gh auth + extensions
gh auth status
gh extension list
```

## Troubleshooting

- **Stow conflicts** during `31_dotfiles-install.sh`: existing files in `$HOME`
  block stow. Remove the offending file and re-run that module.
- **brew install --cask fails on font-***: re-run; sometimes the cask-fonts
  tap takes a moment.
- **gh auth fails**: run `gh auth login --web` manually.
