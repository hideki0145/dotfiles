#!/bin/bash
# Package: node

package_name "node"

case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://github.com/nodejs/node/blob/main/BUILDING.md#official-binary-platforms-and-toolchains
  setup_mise_tool "node@lts" libatomic1
  ;;
darwin)
  setup_mise_tool "node@lts"
  ;;
*) ;;
esac
