setopt CORRECT

autoload -Uz run-help-{ip,openssl,sudo}

alias ack='nocorrect ack'
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias ebuild='nocorrect ebuild'
alias gcc='nocorrect gcc'
alias gist='nocorrect gist'
alias grep='nocorrect grep'
alias heroku='nocorrect heroku'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias mysql='nocorrect mysql'
alias rm='nocorrect rm'

alias bower='noglob bower'
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rake='noglob rake'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

alias _='sudo'
alias b='${(z)BROWSER}'

alias diffu="diff --unified"
alias e='${(z)VISUAL:-${(z)EDITOR}}'
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias p='${(z)PAGER}'
alias po='popd'
alias pu='pushd'
alias sa='alias | grep -i'
alias type='type -a'

alias cpi="${aliases[cp]:-cp} -i"
alias lni="${aliases[ln]:-ln} -i"
alias mvi="${aliases[mv]:-mv} -i"
alias rmi="${aliases[rm]:-rm} -i"

_ls_version="$(ls --version 2>&1)"

if [[ ${(@M)${(f)_ls_version}:#*(GNU|lsd|uutils) *} ]]; then
  alias ls="${aliases[ls]:-ls} --group-directories-first"

  if (( ! $+LS_COLORS )); then
    if is-callable 'dircolors'; then
      eval "$(dircolors --sh $HOME/.dir_colors(N))"
    else
      export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
    fi
  fi

  alias ls="${aliases[ls]:-ls} --color=auto"
else
  if (( ! $+LSCOLORS )); then
    export LSCOLORS='exfxcxdxbxGxDxabagacad'
  fi

  alias ls="${aliases[ls]:-ls} -G"
fi

alias l='ls -1A'
alias ll='ls -lh'
alias lr='ll -R'
alias la='ll -A'
alias lm='la | "$PAGER"'
alias lk='ll -Sr'
alias lt='ll -tr'
alias lc='lt -c'
alias lu='lt -u'

if [[ ${(@M)${(f)_ls_version}:#*GNU *} ]]; then
  alias lx='ll -XB'
fi

unset _ls_version

export GREP_COLOR=${GREP_COLOR:-'37;45'}
export GREP_COLORS=${GREP_COLORS:-"mt=$GREP_COLOR"}

alias grep="${aliases[grep]:-grep} --color=auto"

if is-darwin; then
  alias o='open'
elif is-cygwin; then
  alias o='cygstart'
  alias pbcopy='tee > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
elif is-termux; then
  alias o='termux-open'
  alias pbcopy='termux-clipboard-set'
  alias pbpaste='termux-clipboard-get'
else
  alias o='xdg-open'

  if (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif (( $+commands[xsel] )); then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

_download_helper='curl'

typeset -A _download_helpers=(
  aria2c  'aria2c --continue --remote-time --max-tries=0'
  curl    'curl --continue-at - --location --progress-bar --remote-name --remote-time'
  wget    'wget --continue --progress=bar --timestamping'
)

if (( $+commands[$_download_helper] && $+_download_helpers[$_download_helper] )); then
  alias get="$_download_helpers[$_download_helper]"
elif (( $+commands[curl] )); then
  alias get="$_download_helpers[curl]"
fi

unset _download_helper{,s}

alias df='df -kh'
alias du='du -kh'

if is-darwin || is-bsd; then
  alias topc='top -o cpu'
  alias topm='top -o vsize'
else
  alias topc='top -o %CPU'
  alias topm='top -o %MEM'
fi

if (( $#commands[(i)python(|[23])] )); then
  autoload -Uz is-at-least
  if (( $+commands[python3] )); then
    alias http-serve='python3 -m http.server'
  elif (( $+commands[python2] )); then
    alias http-serve='python2 -m SimpleHTTPServer'
  elif is-at-least 3 ${"$(python --version 2>&1)"[(w)2]}; then
    alias http-serve='python -m http.server'
  else
    alias http-serve='python -m SimpleHTTPServer'
  fi
fi

function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

function pushdls {
  builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

function popdls {
  builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

function slit {
  awk "{ print ${(j:,:):-\$${^@}} }"
}

function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

function noremoteglob {
  local -a argo
  local cmd="$1"
  for arg in ${argv:2}; do case $arg in
    ( ./* ) argo+=( ${~arg} ) ;;
    (  /* ) argo+=( ${~arg} ) ;;
    ( *:* ) argo+=( ${arg}  ) ;;
    (  *  ) argo+=( ${~arg} ) ;;
  esac; done
  command $cmd "${(@)argo}"
}
