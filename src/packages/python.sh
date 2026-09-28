#!/bin/bash
# Package: python

package_name "python"

case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  setup_mise_tool "python@latest" make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libzstd-dev
  ;;
darwin)
  # For reference, see: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  setup_mise_tool "python@latest" openssl@3 readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig
  ;;
*) ;;
esac
