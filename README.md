# Dotfiles

Personal dotfiles and bootstrap script for a fresh Kubuntu/Ubuntu setup.
Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink configs from this repo into `$HOME`.

## Quick Start

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/jlannoo/dotfiles/master/scripts/setup.sh)"
```

Fully automated (no prompts):
```bash
AUTO_INSTALL_MORE=y AUTO_SETUP_DOTFILES=y bash -c "$(curl -fsSL https://raw.githubusercontent.com/jlannoo/dotfiles/master/scripts/setup.sh)"
```

## What Gets Installed

### Always (base setup)
- **git**, **stow**, **curl**, **wget**, **build-essential**, **cmake**
- **Zsh** + Oh My Zsh with plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `you-should-use`
- **Neovim** (kickstart.nvim) + **ripgrep**, **xclip**
- **PipeWire** audio stack

### Optional (`AUTO_INSTALL_MORE=y`)
- **GitHub CLI** (`gh`)
- **nvm** (Node Version Manager)
- **Docker** (CE + compose + buildx)
- **Google Chrome**
- **Tailscale**
- **Flatpak** + Flathub
- Go, Python3 pip + venv, Java (JRE), SQLite3
- ffmpeg, VLC, mpv, OBS Studio, qBittorrent
- MySQL Server
- Android tools (adb, fastboot, scrcpy)
- QDirStat (disk usage)
- Gaming: Steam, Lutris, Protontricks

## Managed Dotfiles

| File | Purpose |
|------|---------|
| `.zshrc` | Zsh config (aliases, plugins, hooks) |
| `.gitconfig` | Git config (user, gh credential helper) |
| `.oh-my-zsh/custom/themes/custom.zsh-theme` | Custom Zsh prompt with git + node info |
| `.config/kglobalshortcutsrc` | KDE global keyboard shortcuts |
| `.config/kdeglobals` | KDE theme, fonts, colors |
| `.config/kwinrc` | KWin window manager settings |
| `.config/konsolerc` | Konsole terminal emulator settings |
| `.config/dolphinrc` | Dolphin file manager settings |
| `.config/kcminputrc` | Mouse/touchpad/keyboard input settings |
| `.config/krunnerrc` | KRunner launcher settings |
| `.config/plasma-org.kde.plasma.desktop-appletsrc` | Plasma panel layout & widgets |
| `.config/hypr/hyprland.conf` | Hyprland window manager config |
| `.local/share/konsole/Profile 1.profile` | Konsole terminal profile |
| `.local/share/plasma-systemmonitor/overview.page` | KDE System Monitor layout |

## Scripts

All scripts are added to `$PATH` via `.zshrc` (`$HOME/scripts` → stowed from `scripts/`).

| Script | Description |
|--------|-------------|
| `setup.sh` | Full bootstrap — installs packages, zsh, neovim, optional software, and dotfiles |
| `dotfiles` | Clones this repo and stows all configs into `$HOME` |
| `open-repo` | Opens the current git repo's remote URL in a browser |
| `php-server` | Runs a PHP dev server in Docker (`-v 8.4 -p 8080 -a` for Apache) |

## Adding New Dotfiles

Place files in this repo mirroring the `$HOME` structure, then re-run `stow .` from the repo root. For example:
```
~/dotfiles/.config/some-app/config → stows to → ~/.config/some-app/config
```

## Suggestions for Additional Backups

- **`~/.ssh/config`** — SSH host aliases (keep repo private or sanitize IPs)
- **`~/.config/easyeffects/`** — Audio processing presets
- **`~/.config/fontconfig/`** — Custom font configuration
- **Nerd Fonts** — Add a script to install preferred coding fonts
- **`~/.npmrc`** / **`~/.bunfig.toml`** — Package manager configs
- **Crontabs** — Export with `crontab -l > crontab.bak`
