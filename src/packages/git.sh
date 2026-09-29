#!/bin/bash
# Package: git

package_name "git"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! grep -qsR git-core/ppa /etc/apt/sources.list /etc/apt/sources.list.d/; then
    sudo add-apt-repository -y ppa:git-core/ppa
    apt_update
  fi
  if ! has "git"; then
    apt_install git
  fi
  ;;
darwin)
  if ! has_formula "git"; then
    brew_install git
  fi
  ;;
*) ;;
esac

git --version
if [ -f "$HOME/.gitconfig" ]; then
  git --no-pager config --global --list
fi
if ! git config --global --get-all include.path >/dev/null; then
  git config --global include.path ~/.gitconfig.local
fi
