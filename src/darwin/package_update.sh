#!/bin/bash
# Package Update Script for Darwin.
echo ""
echo "Package Update start..."
echo ""

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh
. "$DOT_DIR"/src/$(os_name)/utils.sh

brew update && brew upgrade && brew autoremove && brew cleanup

# Package Update complete
echo ""
echo "Package Update complete!"
