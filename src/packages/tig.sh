#!/bin/bash
# Package: tig

package_name "tig"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "tig"; then
    apt_install tig
  fi
  ;;
darwin)
  if ! has_formula "tig"; then
    brew_install tig
  fi
  ;;
*) ;;
esac

tig --version
