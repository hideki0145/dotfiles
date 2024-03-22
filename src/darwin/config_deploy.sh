#!/bin/bash
# Config Deployment Script for Darwin.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh

title "Config Deployment start..."

readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the package setup script first."
fi

declare -a SYMLINK_FILES=(
  "asdf/.default-gems"
  "vim/.vimrc"
  "zsh/.zpreztorc"
  "zsh/$(os_name)/.zshrc"
)

for f in "${SYMLINK_FILES[@]}"; do
  ln -snfv "$DOT_DIR/config/$f" "$HOME/${f##*/}"
done

# Config Deployment complete
result "Config Deployment complete!"
