#!/bin/bash
# Package Update Script for Ubuntu.

# main
. "$DOT_DIR/src/utils.sh"
. "$DOT_DIR/src/$(os_name)/utils.sh"

title "Package Update start..."

sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Package Update complete
result "Package Update complete!"
description "Rebooting may be required."
