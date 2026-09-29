#!/bin/bash
# Package: build-essential (ubuntu only)

case "$DOTFILES_OS_NAME" in
ubuntu) ;;
*) return 0 ;;
esac

if ! has_package "build-essential"; then
  package_name "build-essential"
  sudo apt install -y build-essential
fi
