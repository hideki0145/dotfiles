#!/bin/bash
# Package Update Script for Darwin.

# main
. "$DOT_DIR/src/utils.sh"
. "$DOT_DIR/src/$(os_name)/utils.sh"

title "Package Update start..."

if has_formula "mas"; then
  mas update
fi
if has "brew"; then
  brew update && brew upgrade && brew autoremove && brew cleanup
fi

# Package Update complete
result "Package Update complete!"
