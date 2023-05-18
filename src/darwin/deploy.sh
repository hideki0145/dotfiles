#!/bin/bash
# Deploy Script for Darwin.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh

title "Deploy start..."

readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the setup script first."
fi

declare -a SYMLINK_FILES=(
  "vim/.vimrc"
  "zsh/.zpreztorc"
  "zsh/$(os_name)/.zshrc"
)

for f in "${SYMLINK_FILES[@]}"; do
  ln -snfv "$DOT_DIR/config/$f" "$HOME/${f##*/}"
done

# Deploy complete
result "Deploy complete!"
