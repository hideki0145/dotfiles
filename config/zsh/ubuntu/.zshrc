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

export EDITOR='vim'
export VISUAL='vim'

if [ -z $SSH_AUTH_SOCK ]; then
  readonly SSH_KEY_LIFE_TIME_SEC=3600
  readonly SSH_AGENT_FILE="$HOME/.ssh_agent"
  test -f $SSH_AGENT_FILE && source $SSH_AGENT_FILE > /dev/null 2>&1
  if [ $(ps -ef | grep ssh-agent | grep -v grep | wc -l) -eq 0 ]; then
    ssh-agent -t $SSH_KEY_LIFE_TIME_SEC >! $SSH_AGENT_FILE
    source $SSH_AGENT_FILE > /dev/null 2>&1
  fi
fi

. $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit
