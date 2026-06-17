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

# ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  readonly SSH_KEY_LIFE_TIME_SEC=3600
  readonly SSH_AGENT_FILE="$HOME/.ssh_agent"
  test -f "$SSH_AGENT_FILE" && source "$SSH_AGENT_FILE" >/dev/null 2>&1
  if ! pgrep -x ssh-agent >/dev/null; then
    ssh-agent -t "$SSH_KEY_LIFE_TIME_SEC" | tee "$SSH_AGENT_FILE" >/dev/null
    source "$SSH_AGENT_FILE" >/dev/null 2>&1
  fi
fi

# starship
eval "$(starship init zsh)"

# rustup
. "$HOME/.cargo/env"

# mise
eval "$(~/.local/bin/mise activate zsh)"

# gh
if check_wsl1_or_wsl2; then
  export GH_BROWSER="/mnt/c/Program\ Files/PowerShell/7/pwsh.exe -NoProfile -c start"
fi

# Initialise completions with ZSH's compinit.
autoload -Uz compinit
compinit
