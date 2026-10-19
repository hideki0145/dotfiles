#!/bin/bash
# Package: build-essential (ubuntu only)

case "$DOTFILES_OS_NAME" in
ubuntu) ;;
*) return 0 ;;
esac

if ! has_package "build-essential"; then
  package_name "build-essential"

  apt_install build-essential

  verify_command --format first_line g++ --version &&
    verify_command --format first_line gcc --version &&
    verify_command --format first_line make --version
fi
