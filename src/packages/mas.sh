#!/bin/bash
# Package: mas (darwin only)

case "$DOTFILES_OS_NAME" in
darwin) ;;
*) return 0 ;;
esac

package_name "mas"

if ! has_formula "mas"; then
  brew install -y mas
fi

mas version
