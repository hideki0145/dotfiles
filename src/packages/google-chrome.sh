#!/bin/bash
# Package: google-chrome

package_name "google-chrome"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "google-chrome"; then
    apt_install_deb "https://dl.google.com/linux/direct/google-chrome-stable_current_$(dpkg --print-architecture).deb" "Google Chrome" --no-install-recommends || return 1
  fi

  google-chrome --version
  ;;
darwin)
  if ! has_cask "google-chrome"; then
    brew_install --cask google-chrome
  fi

  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version
  ;;
*) ;;
esac
