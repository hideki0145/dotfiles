#!/bin/bash
# Installation Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
readonly DOTFILES_GITHUB="hideki0145/dotfiles"

if [ ! -d "$DOT_DIR/etc" ]; then
  mkdir -p "$DOT_DIR/etc"
fi
readonly UTILS_SCRIPT="$DOT_DIR/etc/utils.sh"
if [ ! -e "$UTILS_SCRIPT" ]; then
  curl -SL "https://raw.githubusercontent.com/$DOTFILES_GITHUB/main/etc/utils.sh" -o "$UTILS_SCRIPT"
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

if [ "$1" = "setup" -o "$1" = "s" ]; then
  setup
fi

if [ "$1" = "deploy" -o "$1" = "d" ]; then
  deploy
fi
