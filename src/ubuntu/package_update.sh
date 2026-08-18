#!/bin/bash
# Package Update Script for Ubuntu.

if ! ${DOTFILES_RUNNER:-false}; then
  printf "Error: Please run this script via src/run.sh.\n" 1>&2
  exit 1
fi

# main
source "$DOT_DIR/src/utils.sh"
source "$DOT_DIR/src/$DOTFILES_OS_NAME/utils.sh"

title "Package Update start..."

sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean

# Package Update complete
summary_result "Package Update complete!"
summary_description "Rebooting may be required."
