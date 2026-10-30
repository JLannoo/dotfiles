#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Minimal safety and curlable-friendly bootstrap script.
# Designed to be run like:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/jlannoo/dotfiles/master/scripts/setup.sh)"
# or
#   AUTO_INSTALL_MORE=y AUTO_SETUP_DOTFILES=y bash -c "$(curl -fsSL https://raw.githubusercontent.com/jlannoo/dotfiles/master/scripts/setup.sh)"

REPO="https://github.com/jlannoo/dotfiles"
REPO_RAW="https://raw.githubusercontent.com/jlannoo/dotfiles/master"

# Colorful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting basic setup...${NC}"

# Helper functions
command_exists() { command -v "$1" >/dev/null 2>&1; }

ensure_prereqs() {
    if ! command_exists sudo; then
        echo -e "${RED}sudo is required but not installed. Please install sudo and re-run.${NC}" >&2
        exit 1
    fi
}

cleanup() { [ -n "${TMPDIR:-}" ] && rm -rf "${TMPDIR}" || true; }
trap cleanup EXIT

# Detect interactive
interactive=false
if [ -t 0 ]; then interactive=true; fi

# Allow non-interactive usage by exporting environment variables:
# AUTO_INSTALL_MORE=yes AUTO_SETUP_DOTFILES=yes
AUTO_INSTALL_MORE=${AUTO_INSTALL_MORE:-}
AUTO_SETUP_DOTFILES=${AUTO_SETUP_DOTFILES:-}

ensure_prereqs

# Ensure curl or wget present for sub-downloads
if ! command_exists curl && ! command_exists wget; then
    echo -e "${YELLOW}Installing curl (required to fetch remote files)...${NC}"
    sudo apt update
    sudo apt install -y curl ca-certificates
fi

TMPDIR=$(mktemp -d)

# Set DEBIAN_FRONTEND for the entire script to avoid interactive prompts (e.g. tzdata)
export DEBIAN_FRONTEND=noninteractive

echo -e "${YELLOW}Adding necessary repositories...${NC}"
sudo apt update
sudo apt install software-properties-common -y || true
sudo add-apt-repository -y ppa:longsleep/golang-backports || true
sudo add-apt-repository -y ppa:neovim-ppa/unstable || true
sudo apt update

echo -e "${YELLOW}Installing essential packages...${NC}"
sudo apt install -y \
    git \
    stow \
    curl \
    wget \
    build-essential \
    cmake \
    unzip \
    unrar \
    parallel \
    xclip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    sudo \
    pipewire \
    pipewire-audio-client-libraries \
    pipewire-alsa \
    jq \
    bat \
    zip

echo -e "${YELLOW}Installing Zsh...${NC}"
sudo apt install -y zsh

# Install Oh My Zsh without auto-changing shell or running zsh immediately
echo -e "${YELLOW}Installing Oh My Zsh (no auto-run / no chsh)...${NC}"
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# Install zsh plugins if not present
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || true
fi
if [ ! -d "$ZSH_CUSTOM/plugins/you-should-use" ]; then
    git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use.git "$ZSH_CUSTOM/plugins/you-should-use" || true
fi

echo -e "${YELLOW}Setting up neovim-kickstart and dependencies...${NC}"
sudo apt install -y make gcc ripgrep unzip git xclip neovim
if [ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" ]; then
    git clone --depth=1 https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" || true
fi

# Decide whether to install more software
install_more="n"
if [ -n "$AUTO_INSTALL_MORE" ]; then
    install_more="$AUTO_INSTALL_MORE"
elif [ "$interactive" = true ]; then
    read -p "Install more software? (y/n): " install_more || install_more="n"
fi

if [ "$install_more" = "y" ]; then
    echo -e "${YELLOW}Installing additional software...${NC}"

    # GitHub CLI (used by .gitconfig for credential management)
    if ! command_exists gh; then
        echo -e "${YELLOW}Installing GitHub CLI...${NC}"
        (type -p wget >/dev/null || sudo apt install -y wget) \
            && sudo mkdir -p -m 755 /etc/apt/keyrings \
            && out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
            && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
            && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
            && sudo apt update && sudo apt install -y gh || true
    fi

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash || true

    # Docker setup
    echo -e "${YELLOW}Setting up Docker...${NC}"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || true
    sudo chmod a+r /etc/apt/keyrings/docker.asc || true
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    sudo apt update || true

    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin || true

    sudo apt install -y \
        ffmpeg \
        vlc \
        obs-studio \
        qbittorrent \
        flatpak \
        golang-go \
        python3-pip \
        python3-venv \
        default-jre \
        sqlite3 \
        libsqlite3-dev \
        mysql-server \
        adb \
        fastboot \
        scrcpy \
        qdirstat || true

    # Setup Flathub remote for Flatpak
    if command_exists flatpak; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
    fi

    # Google Chrome
    if ! command_exists google-chrome-stable; then
        echo -e "${YELLOW}Installing Google Chrome...${NC}"
        wget -q -O "$TMPDIR/chrome.deb" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo dpkg -i "$TMPDIR/chrome.deb" || sudo apt install -f -y || true
    fi

    # Tailscale
    if ! command_exists tailscale; then
        echo -e "${YELLOW}Installing Tailscale...${NC}"
        curl -fsSL https://tailscale.com/install.sh | sh || true
    fi

    # Gaming (Steam, Lutris, Protontricks)
    echo -e "${YELLOW}Installing gaming software...${NC}"
    sudo apt install -y \
        steam \
        lutris \
        protontricks || true
fi

echo -e "${GREEN}Basic setup completed!${NC}"

# Dotfiles setup: if running from repo clone, use local script; otherwise fetch raw
setup_dotfiles="n"
if [ -n "$AUTO_SETUP_DOTFILES" ]; then
    setup_dotfiles="$AUTO_SETUP_DOTFILES"
elif [ "$interactive" = true ]; then
    read -p "Setup dotfiles now? (y/n): " setup_dotfiles || setup_dotfiles="n"
fi

if [ "$setup_dotfiles" = "y" ]; then
    echo -e "${YELLOW}Setting up dotfiles...${NC}"
    if [ -f scripts/dotfiles ]; then
        bash scripts/dotfiles || true
    else
        # use raw.githubusercontent to avoid HTML
        echo -e "${YELLOW}Fetching and running dotfiles setup script...${NC}"
        if command_exists curl; then
            bash -e <(curl -fsSL "$REPO_RAW/scripts/dotfiles") || true
        else
            bash -e <(wget -qO- "$REPO_RAW/scripts/dotfiles") || true
        fi
    fi
fi

# Offer to change shell to zsh if not already
if [ "$(basename "$SHELL")" != "zsh" ]; then
    if [ "$interactive" = true ]; then
        read -p "Change default shell to zsh now? (y/n): " change_shell || change_shell="n"
        if [ "$change_shell" = "y" ]; then
            chsh -s "$(command -v zsh)" || true
            echo -e "${GREEN}Shell changed to zsh. Log out / restart terminal to take effect.${NC}"
        fi
    else
        echo -e "${YELLOW}Non-interactive: skipping automatic chsh. Use 'chsh -s $(command -v zsh)' to change shell.${NC}"
    fi
fi

echo -e "${GREEN}Setup script finished! Please restart your terminal.${NC}"