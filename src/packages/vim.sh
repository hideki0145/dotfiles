#!/bin/bash
# Package: vim

package_name "vim"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "vim"; then
    sudo apt install -y vim
  fi
  ;;
darwin)
  if ! has_formula "vim"; then
    brew install -y vim
  fi
  ;;
*) ;;
esac

vim --version | head -n 1
