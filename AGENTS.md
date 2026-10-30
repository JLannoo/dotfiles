# Dotfiles Repository — Agent Context

## Overview
Personal dotfiles repo for a **Kubuntu** desktop. Uses **GNU Stow** to symlink files from this repo into `$HOME`. Target audience: a single user (JLannoo) bootstrapping a fresh Ubuntu-based machine.

## Architecture

### Stow Convention
The repo root IS the stow package. Every file/directory here mirrors its position relative to `$HOME`. Running `stow .` from the repo root creates symlinks.

Example: `~/dotfiles/.config/hypr/hyprland.conf` → symlinks to `~/.config/hypr/hyprland.conf`.

**Important:** The `scripts/` directory stows to `~/scripts/` which is on `$PATH` via `.zshrc`.

### Bootstrap Flow
1. User runs `setup.sh` via curl (or locally)
2. `setup.sh` installs system packages, zsh, oh-my-zsh, neovim
3. Optionally installs extended software (Docker, gh, nvm, Chrome, Tailscale, gaming, etc.)
4. Optionally calls `scripts/dotfiles` which clones this repo and stows everything
5. `scripts/dotfiles` uses `stow --adopt` to handle existing files without conflicts

### Key Files
- **`scripts/setup.sh`** — Main bootstrap entry point. Designed to be curl-piped. Supports `AUTO_INSTALL_MORE` and `AUTO_SETUP_DOTFILES` env vars for non-interactive use.
- **`scripts/dotfiles`** — Clones repo + runs stow. Self-contained (defines its own variables).
- **`scripts/open-repo`** — Opens current git repo's remote in browser (handles SSH→HTTPS conversion).
- **`scripts/php-server`** — Docker-based PHP dev server with Apache.
- **`.zshrc`** — Shell config. Plugins: git, npm, nvm, zsh-autosuggestions, you-should-use, zsh-syntax-highlighting. Has hooks for auto-activating `.nvmrc` and Python venvs on `cd`.
- **`.gitconfig`** — Uses `gh auth git-credential` for GitHub auth.
- **`.config/kglobalshortcutsrc`** — KDE global keyboard shortcuts.
- **`.config/kdeglobals`** — KDE theme, fonts, color scheme.
- **`.config/kwinrc`** — KWin window manager settings.
- **`.config/konsolerc`** — Konsole terminal emulator settings.
- **`.config/dolphinrc`** — Dolphin file manager settings.
- **`.config/kcminputrc`** — Mouse/touchpad/keyboard input settings.
- **`.config/krunnerrc`** — KRunner launcher settings.
- **`.config/plasma-org.kde.plasma.desktop-appletsrc`** — Plasma panel layout and widgets.
- **`.config/hypr/hyprland.conf`** — Hyprland window manager config (alternative WM).
- **`.local/share/konsole/Profile 1.profile`** — Konsole terminal profile.
- **`.local/share/plasma-systemmonitor/overview.page`** — KDE System Monitor layout.

## Conventions
- All shell scripts use `#!/usr/bin/env bash` with `set -euo pipefail`
- Colors: RED/GREEN/YELLOW/NC variables for terminal output
- Packages installed with `DEBIAN_FRONTEND=noninteractive` and `|| true` for resilience
- The repo targets **Ubuntu/Kubuntu** (apt-based). Other distros need adaptation.
- Interactive prompts are skipped when stdin is not a TTY or when `AUTO_*` env vars are set.

## What Doesn't Belong Here
- Private SSH keys (only `~/.ssh/config` host definitions are safe)
- Secrets, tokens, API keys
- Large binary files
- Machine-specific hardware configs (those should be parameterized)

## Common Tasks for Agents
- **Adding a new dotfile:** Create it mirroring the `$HOME` path, update README table.
- **Adding a new package to setup:** Add to the appropriate `apt install` block in `setup.sh`.
- **Adding a new script:** Create in `scripts/`, make executable, add to README scripts table.

## Known Issues / Debt
- VS Code `settings.json` is cloud-synced and NOT tracked in this repo.
- KDE config files may contain machine-specific values (monitor names, device IDs). Review after stowing on a new machine.
