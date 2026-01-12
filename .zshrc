# ===== ENVIRONMENT VARIABLES =====
export ZSH="$HOME/.oh-my-zsh"
export EMSDK_QUIET=1
export PATH=$PATH:~/scripts/

# ===== THEME =====
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="custom"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

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

function chpwd() {
	nvm_sync
}

nvm_sync

# ===== ALIASES =====
alias vim="nvim"
alias rzsh="source ~/.zshrc"


