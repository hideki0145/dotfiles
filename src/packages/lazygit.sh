#!/bin/bash
# Package: lazygit

package_name "lazygit"

case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://github.com/jesseduffield/lazygit?tab=readme-ov-file#debian-and-ubuntu
  require_github_latest_version "jesseduffield/lazygit" LAZYGIT_VERSION || return 0
  if ! has "lazygit" || [ ! "$LAZYGIT_VERSION" = "$(lazygit --version | sed -n 's/^.*, version=\([^,[:space:]]*\).*$/\1/p')" ]; then
    LAZYGIT_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
    download_file "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_$(uname -s)_${LAZYGIT_ARCH}.tar.gz" "$DOT_DIR/tmp/lazygit.tar.gz" "lazygit ${LAZYGIT_VERSION}" || return 0
    tar xf "$DOT_DIR/tmp/lazygit.tar.gz" -C "$DOT_DIR/tmp" lazygit
    sudo install "$DOT_DIR/tmp/lazygit" -D -t /usr/local/bin/
    rm "$DOT_DIR/tmp/lazygit.tar.gz" "$DOT_DIR/tmp/lazygit"
  fi
  ;;
darwin)
  if ! has_formula "lazygit"; then
    brew install -y lazygit
  fi
  ;;
*) ;;
esac

lazygit --version
