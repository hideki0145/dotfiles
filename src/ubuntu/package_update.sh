#!/bin/bash
# Package Update Script for Ubuntu.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh
. "$DOT_DIR"/src/$(os_name)/utils.sh

sudo -v &> /dev/null
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done &> /dev/null &

sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Package Update complete
echo ""
echo "Package Update complete!"
echo "Rebooting may be required."
