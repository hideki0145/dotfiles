autoload -Uz is-at-least
if [[ $ZSH_VERSION != 5.1.1 && $TERM != dumb ]]; then
  if is-at-least 5.2; then
    autoload -Uz bracketed-paste-url-magic
    zle -N bracketed-paste bracketed-paste-url-magic
  elif is-at-least 5.1; then
    autoload -Uz bracketed-paste-magic
    zle -N bracketed-paste bracketed-paste-magic
  fi
  autoload -Uz url-quote-magic
  zle -N self-insert url-quote-magic
fi

setopt COMBINING_CHARS
setopt INTERACTIVE_COMMENTS
setopt RC_QUOTES
unsetopt MAIL_WARNING

[[ -r ${TTY:-} && -w ${TTY:-} && $+commands[stty] == 1 ]] && stty -ixon <$TTY >$TTY

setopt LONG_LIST_JOBS
setopt AUTO_RESUME
setopt NOTIFY
unsetopt BG_NICE
unsetopt HUP
unsetopt CHECK_JOBS

if [[ $TERM != dumb ]]; then
  export LESS_TERMCAP_mb=$'\E[01;31m'
  export LESS_TERMCAP_md=$'\E[01;31m'
  export LESS_TERMCAP_me=$'\E[0m'
  export LESS_TERMCAP_se=$'\E[0m'
  export LESS_TERMCAP_so=$'\E[00;47;30m'
  export LESS_TERMCAP_ue=$'\E[0m'
  export LESS_TERMCAP_us=$'\E[01;32m'
fi
