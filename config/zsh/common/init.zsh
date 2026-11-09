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
source "$HOME/.dotfiles/config/zsh/common/functions.zsh"

export EDITOR="vim"
export VISUAL="vim"

# rustup
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# mise
if [[ -x "$HOME/.local/bin/mise" ]]; then
  _mise_activate() {
    eval "$("$HOME/.local/bin/mise" activate zsh)"
  }
  # Defer activation until ZLE is idle and keep errors visible.
  if (( $+functions[zsh-defer] )); then
    zsh-defer -2 _mise_activate
  else
    _mise_activate
  fi
fi

# starship
(( $+commands[starship] )) && eval "$(starship init zsh)"
