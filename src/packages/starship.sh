#!/bin/bash
# Package: starship

package_name "starship"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if require_github_latest_version "starship/starship" STARSHIP_VERSION; then
    if ! has "starship" || [ ! "$STARSHIP_VERSION" = "$(starship --version | sed -n 's/^starship \([^[:space:]]*\).*$/\1/p')" ]; then
      curl -sS https://starship.rs/install.sh | sh -s -- --force >/dev/null
    fi
  fi
  ;;
darwin)
  if ! has_formula "starship"; then
    brew_install starship
  fi
  ;;
*) ;;
esac

verify_command --format first_line starship --version
