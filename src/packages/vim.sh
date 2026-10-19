#!/bin/bash
# Package: vim

package_name "vim"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "vim"; then
    apt_install vim
  fi
  ;;
darwin)
  if ! has_formula "vim"; then
    brew_install vim
  fi
  ;;
*) ;;
esac

verify_command --format first_line vim --version
