#!/bin/bash
# Package: curl (ubuntu only)

case "$DOTFILES_OS_NAME" in
ubuntu) ;;
*) return 0 ;;
esac

if ! has "curl"; then
  sudo apt install -y curl
fi
