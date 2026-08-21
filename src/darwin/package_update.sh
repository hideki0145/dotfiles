#!/bin/bash
# Package Update Script for Darwin.

if ! ${DOTFILES_RUNNER:-false}; then
  printf "Error: Please run this script via src/run.sh.\n" 1>&2
  exit 1
fi

# main
source "$DOT_DIR/src/utils.sh"
source "$DOT_DIR/src/$DOTFILES_OS_NAME/utils.sh"

title "Package Update start..."

if has "brew"; then
  if has_formula "mas"; then
    mas update
  fi
  brew update && brew upgrade -y && brew autoremove && brew cleanup
fi
if has "uv"; then
  uv tool upgrade --all
fi
if has "rustup"; then
  rustup update --no-self-update
fi
if has "mise"; then
  mise plugins update
  mise -C "$HOME" upgrade
fi

# Package Update complete
summary_result "Package Update complete!"
