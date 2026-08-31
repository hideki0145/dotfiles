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
DOT_DIR="$HOME/.dotfiles"
UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
source "$UTILS_SCRIPT"
source "$DOT_DIR/src/$(os_name)/utils.sh"

export EDITOR="vim"
export VISUAL="vim"

# rustup
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# mise
[[ -x "$HOME/.local/bin/mise" ]] && eval "$("$HOME/.local/bin/mise" activate zsh)"

# starship
(( $+commands[starship] )) && eval "$(starship init zsh)"
