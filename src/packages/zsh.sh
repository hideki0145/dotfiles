#!/bin/bash
# Package: zsh

package_name "zsh"

case "$DOTFILES_OS_NAME" in
ubuntu)
  if ! has "zsh"; then
    sudo apt install -y zsh
    description "Change login shell."
    sudo sed -i.bak -e "/auth.*required.*pam_shells.so/s/required/sufficient/g" /etc/pam.d/chsh
    chsh -s "$(which zsh)"
    sudo sed -i.bak -e "/auth.*sufficient.*pam_shells.so/s/sufficient/required/g" /etc/pam.d/chsh
    cp "$DOT_DIR/config/zsh/$DOTFILES_OS_NAME/.zsh_history.sample" "${ZDOTDIR:-$HOME}/.zsh_history"
  fi
  ;;
darwin)
  if ! has_formula "zsh"; then
    brew install -y zsh
    description "Change login shell."
    sudo sh -c 'echo "/opt/homebrew/bin/zsh" >> /etc/shells'
    chsh -s /opt/homebrew/bin/zsh
    cp "$DOT_DIR/config/zsh/$DOTFILES_OS_NAME/.zsh_history.sample" "${ZDOTDIR:-$HOME}/.zsh_history"
  fi
  ;;
*) ;;
esac

zsh --version
