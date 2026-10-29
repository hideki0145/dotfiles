#!/bin/bash
# Package: zip / unzip (ubuntu only)

case "$DOTFILES_OS_NAME" in
ubuntu) ;;
*) return 0 ;;
esac

if ! has "zip" || ! has "unzip"; then
  package_name "zip"

  apt_install zip unzip

  verify_command --format first_two_lines zip --version &&
    verify_command --format first_line unzip -v
fi
