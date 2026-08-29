#!/bin/bash
# Package: sqlite3

package_name "sqlite3"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "sqlite3"; then
    sudo apt install -y sqlite3 libsqlite3-dev
  fi
  ;;
darwin)
  if ! has_formula "sqlite"; then
    brew install -y sqlite
  fi
  ;;
*) ;;
esac

sqlite3 --version
