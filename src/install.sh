#!/bin/bash
# Installation Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
readonly DOTFILES_GITHUB="hideki0145/dotfiles"

if [ ! -d "$DOT_DIR/src" ]; then
  mkdir -p "$DOT_DIR/src"
fi
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
if [ ! -f "$UTILS_SCRIPT" ]; then
  curl -SL "https://raw.githubusercontent.com/$DOTFILES_GITHUB/main/src/utils.sh" -o "$UTILS_SCRIPT"
  chmod 755 "$UTILS_SCRIPT"
fi
. "$UTILS_SCRIPT"

if [ ! -d "$DOT_DIR" ]; then
  if has "git"; then
    git clone "https://github.com/$DOTFILES_GITHUB.git" "$DOT_DIR"
  elif has "curl" || has "wget"; then
    readonly TARBALL="https://github.com/$DOTFILES_GITHUB/archive/main.tar.gz"
    if has "curl"; then
      curl -L "$TARBALL"
    elif has "wget"; then
      wget -O - "$TARBALL"
    fi | tar zxv
    mv -f dotfiles-main "$DOT_DIR"
  else
    error "curl or wget required."
  fi
elif [ -d "$DOT_DIR/.git" ]; then
  cd "$DOT_DIR"
  git pull
fi

if [ ! -d "$DOT_DIR" ]; then
  error "not found: $DOT_DIR"
fi

while [ $# -gt 0 ]; do
  case $1 in
    -s | --setup)
      setup
      ;;
    -d | --deploy)
      deploy
      ;;
    -*)
      error "invalid option $1."
      ;;
    *)
      echo "argument $1."
      ;;
  esac
  shift
done
