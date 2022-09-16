#!/bin/bash
# Deploy Script for Darwin.

# main
readonly DOT_DIR="$HOME/.dotfiles"
declare -a SYMLINK_FILES=(
  "vim/.vimrc"
  "zsh/.zpreztorc"
  "zsh/darwin/.zshrc"
)

for f in "${SYMLINK_FILES[@]}"; do
  ln -snfv "$DOT_DIR/config/$f" "$HOME/${f##*/}"
done

# Deploy complete
echo ""
echo "Deploy complete!"
