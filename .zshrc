# ===== ENVIRONMENT VARIABLES =====
export ZSH="$HOME/.oh-my-zsh"
export EMSDK_QUIET=1
export NVM_LAZY_LOAD=true
export BUN_INSTALL="$HOME/.bun"

export PATH=$PATH:$HOME/scripts
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.bun/bin
export PATH=$PATH:$HOME/.opencode/bin

# ===== THEME =====
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="custom"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto      	# update automatically without asking
zstyle ':omz:plugins:nvm' lazy yes	# Lazyload NVM
# zstyle ':omz:update' mode disabled  	# disable automatic updates
# zstyle ':omz:update' mode reminder  	# just remind me to update when it's time

# ===== PLUGINS =====
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
	git
	npm
	nvm
	zsh-autosuggestions
	you-should-use
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# ===== HOOKS =====
function nvm_sync() {
	if [[ -f .nvmrc ]]; then
		nvm use
	fi
}

function venv_activate() {
	if [[ -f .venv/bin/activate ]]; then
		source .venv/bin/activate
	fi
	if [[ -f venv/bin/activate ]]; then
		source venv/bin/activate
	fi
}

function chpwd() {
	nvm_sync
}

nvm_sync
venv_activate

# ===== ALIASES =====
alias vim="nvim"
alias rzsh="source ~/.zshrc"
alias py="python3"
alias adb-unlock="adb shell input keyevent 26 && adb shell input swipe 200 600 200 0"
alias aptdate="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
alias winreboot="sudo grub-reboot 'Windows Boot Manager (on /dev/sdc1)' && sudo reboot"
