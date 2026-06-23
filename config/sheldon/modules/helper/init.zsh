function is-autoloadable {
  ( unfunction $1 ; autoload -U +X $1 ) &> /dev/null
}

function is-callable {
  (( $+commands[$1] || $+functions[$1] || $+aliases[$1] || $+builtins[$1] ))
}

function is-true {
  [[ -n "$1" && "$1" == (1|[Yy]([Ee][Ss]|)|[Tt]([Rr][Uu][Ee]|)|[Oo]([Nn]|)) ]]
}

function coalesce {
  for arg in $argv; do
    print "$arg"
    return 0
  done
  return 1
}

function is-darwin {
  [[ "$OSTYPE" == darwin* ]]
}

function is-linux {
  [[ "$OSTYPE" == linux* ]]
}

function is-bsd {
  [[ "$OSTYPE" == *bsd* ]]
}

function is-cygwin {
  [[ "$OSTYPE" == cygwin* ]]
}

function is-termux {
  [[ "$OSTYPE" == linux-android ]]
}
