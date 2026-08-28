#!/bin/bash
# Package: delta

package_name "delta"

case "$DOTFILES_OS_NAME" in
ubuntu)
  DELTA_VERSION=$(get_github_latest_version "dandavison/delta")
  if ! has "delta" || [ ! "$DELTA_VERSION" = "$(delta --version | sed -n 's/^delta \([^[:space:]]*\).*$/\1/p')" ]; then
    curl -LsS "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_$(dpkg --print-architecture).deb" -o "/tmp/git-delta_${DELTA_VERSION}_$(dpkg --print-architecture).deb"
    sudo apt install -y "/tmp/git-delta_${DELTA_VERSION}_$(dpkg --print-architecture).deb"
    rm "/tmp/git-delta_${DELTA_VERSION}_$(dpkg --print-architecture).deb"
  fi
  ;;
darwin)
  if ! has_formula "git-delta"; then
    brew install -y git-delta
  fi
  ;;
*) ;;
esac

delta --version
case "$DOTFILES_OS_NAME" in
ubuntu)
  delta --generate-completion zsh | tee ~/.zsh/completions/_delta >/dev/null
  ;;
darwin) ;;
*) ;;
esac
