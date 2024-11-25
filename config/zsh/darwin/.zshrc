#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.mise.zsh

# Customize to your needs...
readonly DOT_DIR="$HOME/.dotfiles"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
. "$UTILS_SCRIPT"
. "$DOT_DIR"/src/$(os_name)/utils.sh

export EDITOR='vim'
export VISUAL='vim'
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# zsh
FPATH="$HOME/.zsh/completions:$FPATH"

# rustup
. "$HOME/.cargo/env"

# mise
eval "$(~/.local/bin/mise activate zsh)"
mise_select() {
  [[ -z "$1" ]] && return 1 || mise use "$1@$(mise ls-remote "$1" | sort -rV | fzf)"
}

# postgresql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Initialise completions with ZSH's compinit.
autoload -Uz compinit
compinit
