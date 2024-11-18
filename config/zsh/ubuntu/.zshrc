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

# Customize to your needs...
readonly DOT_DIR="$HOME/.dotfiles"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
. "$UTILS_SCRIPT"
. "$DOT_DIR"/src/$(os_name)/utils.sh

export EDITOR='vim'
export VISUAL='vim'

# ssh-agent
if [ -z $SSH_AUTH_SOCK ]; then
  readonly SSH_KEY_LIFE_TIME_SEC=3600
  readonly SSH_AGENT_FILE="$HOME/.ssh_agent"
  test -f $SSH_AGENT_FILE && source $SSH_AGENT_FILE > /dev/null 2>&1
  if [ $(ps -ef | grep ssh-agent | grep -v grep | wc -l) -eq 0 ]; then
    ssh-agent -t $SSH_KEY_LIFE_TIME_SEC >! $SSH_AGENT_FILE
    source $SSH_AGENT_FILE > /dev/null 2>&1
  fi
fi

# rustup
. "$HOME/.cargo/env"

# asdf
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

# gh
if check_wsl1_or_wsl2; then
  export GH_BROWSER="/mnt/c/Program\ Files/PowerShell/7/pwsh.exe -NoProfile -c start"
fi

# Initialise completions with ZSH's compinit.
autoload -Uz compinit
compinit
