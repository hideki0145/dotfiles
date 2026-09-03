#!/bin/bash
# Package: zsh

package_name "zsh"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "zsh"; then
    sudo apt install -y zsh
    description "Change login shell."
    sudo chsh -s "$(which zsh)" "$USER"
    cp "$DOT_DIR/config/zsh/$DOTFILES_OS_NAME/.zsh_history.sample" "${ZDOTDIR:-$HOME}/.zsh_history"
  fi
  ;;
darwin)
  if ! has_formula "zsh"; then
    brew install -y zsh
    description "Change login shell."
    if ! grep -qxF "/opt/homebrew/bin/zsh" /etc/shells; then
      sudo sh -c 'echo "/opt/homebrew/bin/zsh" >> /etc/shells'
    fi
    chsh -s /opt/homebrew/bin/zsh
    cp "$DOT_DIR/config/zsh/$DOTFILES_OS_NAME/.zsh_history.sample" "${ZDOTDIR:-$HOME}/.zsh_history"
  fi
  ;;
*) ;;
esac

zsh --version
