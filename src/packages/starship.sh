#!/bin/bash
# Package: starship

package_name "starship"

case "$DOTFILES_OS_NAME" in
ubuntu)
  STARSHIP_VERSION=$(get_github_latest_version "starship/starship")
  if ! has "starship" || [ ! "$STARSHIP_VERSION" = "$(starship --version | sed -n 's/^starship \([^[:space:]]*\).*$/\1/p')" ]; then
    curl -sS https://starship.rs/install.sh | sh -s -- --force >/dev/null
  fi
  ;;
darwin)
  if ! has_formula "starship"; then
    brew install -y starship
  fi
  ;;
*) ;;
esac

starship --version
