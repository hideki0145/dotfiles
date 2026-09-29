#!/bin/bash
# Package: google-chrome

package_name "google-chrome"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "google-chrome"; then
    deb_file="$(mktemp --suffix=.deb /tmp/google-chrome.XXXXXXXXXX)" || return 0
    download_file "https://dl.google.com/linux/direct/google-chrome-stable_current_$(dpkg --print-architecture).deb" "$deb_file" "Google Chrome" || {
      rm -f "$deb_file"
      return 0
    }
    chmod 644 "$deb_file" || {
      rm -f "$deb_file"
      return 0
    }
    apt_install "$deb_file"
    rm -f "$deb_file"
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
