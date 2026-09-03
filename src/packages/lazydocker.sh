#!/bin/bash
# Package: lazydocker

package_name "lazydocker"

case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://github.com/jesseduffield/lazydocker?tab=readme-ov-file#binary-release-linuxosxwindows
  require_github_latest_version "jesseduffield/lazydocker" LAZYDOCKER_VERSION || return 0
  if ! has "lazydocker" || [ ! "$LAZYDOCKER_VERSION" = "$(lazydocker --version | sed -n 's/^Version: \([^[:space:]]*\).*$/\1/p')" ]; then
    LAZYDOCKER_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
    download_file "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_$(uname -s)_${LAZYDOCKER_ARCH}.tar.gz" "$DOT_DIR/tmp/lazydocker.tar.gz" "lazydocker ${LAZYDOCKER_VERSION}" || return 0
    tar xf "$DOT_DIR/tmp/lazydocker.tar.gz" -C "$DOT_DIR/tmp" lazydocker
    sudo install "$DOT_DIR/tmp/lazydocker" -D -t /usr/local/bin/
    rm "$DOT_DIR/tmp/lazydocker.tar.gz" "$DOT_DIR/tmp/lazydocker"
  fi
  ;;
darwin)
  if ! has_formula "lazydocker"; then
    brew install -y lazydocker
  fi
  ;;
*) ;;
esac

lazydocker --version
