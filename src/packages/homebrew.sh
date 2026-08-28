#!/bin/bash
# Package: homebrew (darwin only)

case "$DOTFILES_OS_NAME" in
darwin) ;;
*) return 0 ;;
esac

package_name "homebrew"

if ! has "brew"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv bash)"
fi

brew --version
