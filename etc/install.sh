#!/bin/bash
# Installation Script.

# Check existence of the command.
has() {
  type "$1" >/dev/null 2>&1
  return $?
}

# Display error message and returns exit code error.
error() {
  echo "$1" 1>&2
  exit 1
}

# Initialize of packages.
init() {
  cd "$DOT_DIR"
  bash ./etc/init.sh
  return 0
}

# Deployment of dotfiles.
deploy() {
  cd "$DOT_DIR"
  for f in .??*
  do
    [ "$f" = ".git" ] && continue
    ln -snfv "$DOT_DIR/$f" "$HOME/$f"
  done
  return 0
}

# main
readonly DOT_DIR="$HOME/.dotfiles"
readonly DOTFILES_GITHUB="https://github.com/hideki0145/dotfiles.git"

if [ ! -d "$DOT_DIR" ]; then
  if has "git"; then
    git clone "$DOTFILES_GITHUB" "$DOT_DIR"
  elif has "curl" || has "wget"; then
    local _tarball="https://github.com/hideki0145/dotfiles/archive/master.tar.gz"
    if has "curl"; then
      curl -L "$_tarball"
    elif has "wget"; then
      wget -O "$_tarball"
    fi | tar zxv
    mv -f dotfiles-master "$DOT_DIR"
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

if [ "$1" = "init" -o "$1" = "i" ]; then
  init
fi

if [ "$1" = "deploy" -o "$1" = "d" ]; then
  deploy
fi
