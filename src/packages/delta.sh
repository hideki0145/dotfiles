#!/bin/bash
# Package: delta

package_name "delta"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if require_github_latest_version "dandavison/delta" DELTA_VERSION; then
    if ! has "delta" || [ ! "$DELTA_VERSION" = "$(delta --version | sed -n 's/^delta \([^[:space:]]*\).*$/\1/p')" ]; then
      apt_install_deb "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_$(dpkg --print-architecture).deb" "delta ${DELTA_VERSION}"
    fi
  fi
  ;;
darwin)
  if ! has_formula "git-delta"; then
    brew_install git-delta
  fi
  ;;
*) ;;
esac

case "$DOTFILES_OS_NAME" in
ubuntu)
  has delta && delta --generate-completion zsh | tee ~/.zsh/completions/_delta >/dev/null
  ;;
darwin) ;;
*) ;;
esac

verify_command delta --version
