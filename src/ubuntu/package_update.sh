#!/bin/bash
# Package Update Script for Ubuntu.

# main
source "$DOT_DIR/src/utils.sh"
source "$DOT_DIR/src/$(os_name)/utils.sh"

title "Package Update start..."

sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Package Update complete
summary_result "Package Update complete!"
summary_description "Rebooting may be required."
