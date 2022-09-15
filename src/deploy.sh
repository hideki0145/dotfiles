#!/bin/bash
# Deploy Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
declare -a SYMLINK_FILES=(
  "vim/.vimrc"
  "zsh/.zpreztorc"
  "zsh/.zshrc"
)

for f in "${SYMLINK_FILES[@]}"; do
  ln -snfv "$DOT_DIR/config/$f" "$HOME/${f##*/}"
done

# Deploy complete
echo ""
echo "Deploy complete!"
