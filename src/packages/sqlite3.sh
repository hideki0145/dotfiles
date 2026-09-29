#!/bin/bash
# Package: sqlite3

package_name "sqlite3"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "sqlite3"; then
    apt_install sqlite3 libsqlite3-dev
  fi
  ;;
darwin)
  if ! has_formula "sqlite"; then
    brew_install sqlite
  fi
  ;;
*) ;;
esac

sqlite3 --version
