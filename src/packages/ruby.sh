#!/bin/bash
# Package: ruby

package_name "ruby"

case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  setup_mise_tool "ruby@latest" build-essential autoconf libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev rustc
  ;;
darwin)
  # For reference, see: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  setup_mise_tool "ruby@latest" openssl@3 readline libyaml gmp autoconf
  ;;
*) ;;
esac
