#!/bin/bash
# Package: gh

package_name "gh"

case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
  if ! has "gh"; then
    type -p wget >/dev/null || (sudo apt update -qq && sudo apt install -y wget)
    sudo mkdir -p -m 755 /etc/apt/keyrings
    out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
    cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    sudo mkdir -p -m 755 /etc/apt/sources.list.d
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt update -qq
    sudo apt install -y gh
  fi
  ;;
darwin)
  if ! has_formula "gh"; then
    brew install -y gh
  fi
  ;;
*) ;;
esac

gh --version
