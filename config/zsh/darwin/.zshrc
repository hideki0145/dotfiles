#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
readonly DOT_DIR="$HOME/.dotfiles"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
. "$UTILS_SCRIPT"
. "$DOT_DIR/src/$(os_name)/utils.sh"

export EDITOR="vim"
export VISUAL="vim"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# zsh
FPATH="$HOME/.zsh/completions:$FPATH"

# starship
eval "$(starship init zsh)"

# rustup
. "$HOME/.cargo/env"

# mise
eval "$(~/.local/bin/mise activate zsh)"

# postgresql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Initialise completions with ZSH's compinit.
autoload -Uz compinit
compinit
