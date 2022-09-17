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
export EDITOR='vim'
export VISUAL='vim'

# Check existence of the command.
has() {
  type "$1" > /dev/null 2>&1
  return $?
}

function isWinDir {
 case $PWD/ in
   /mnt/*) return $(true);;
   *) return $(false);;
 esac
}
function git {
 if isWinDir; then
   git.exe "$@"
 else
   /usr/bin/git "$@"
 fi
}

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

if has "genie"; then
  # Are we in the bottle?
  if [[ ! -v INSIDE_GENIE ]]; then
    read -t 3 -q "yn? * Preparing to enter genie bottle (in 3s); abort? "
    echo

    if [[ $yn != "y" ]]; then
      echo "Starting genie:"
      exec /usr/bin/genie -c "zsh"
    fi
  fi
fi
