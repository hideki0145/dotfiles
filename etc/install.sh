#!/bin/bash
# Installation Script.

# Check existence of the command.
has() {
  type "$1" > /dev/null 2>&1
  return $?
}

# Display error message and returns exit code error.
error() {
  echo "$1" 1>&2
  exit 1
}

# Setup of packages.
setup() {
  bash "$DOT_DIR"/etc/setup.sh
  return 0
}

# Deployment of dotfiles.
deploy() {
  for f in "$DOT_DIR"/.??*
  do
    [ "${f##*/}" = ".git" -o "${f##*/}" = ".gitignore" ] && continue
    ln -snfv "$f" "$HOME/${f##*/}"
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
    readonly TARBALL="https://github.com/hideki0145/dotfiles/archive/main.tar.gz"
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
