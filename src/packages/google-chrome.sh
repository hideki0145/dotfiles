#!/bin/bash
# Package: google-chrome

package_name "google-chrome"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "google-chrome"; then
    curl -LsS "https://dl.google.com/linux/direct/google-chrome-stable_current_$(dpkg --print-architecture).deb" -o "/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
    sudo apt install -y "/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
    rm "/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  fi

  google-chrome --version
  ;;
darwin)
  if ! has_cask "google-chrome"; then
    brew install -y --cask google-chrome
  fi

  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version
  ;;
*) ;;
esac
