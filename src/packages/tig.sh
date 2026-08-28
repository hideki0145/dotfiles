#!/bin/bash
# Package: tig

package_name "tig"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "tig"; then
    sudo apt install -y tig
  fi
  ;;
darwin)
  if ! has_formula "tig"; then
    brew install -y tig
  fi
  ;;
*) ;;
esac

tig --version
