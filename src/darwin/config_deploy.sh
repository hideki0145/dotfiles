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

declare -a SYMLINK_ENTRIES=(
  "docker/$(os_name)/config.json|$HOME/.docker/"
  "git/.gitconfig|$HOME/"
  "git/ignore|$HOME/.config/git/"
  "mise/.default-gems|$HOME/"
  "vim/.vimrc|$HOME/"
  "zsh/.p10k.zsh|$HOME/"
  "zsh/.zpreztorc|$HOME/"
  "zsh/$(os_name)/.zshrc|$HOME/"
)

for entry in "${SYMLINK_ENTRIES[@]}"; do
  file=${entry%%|*}
  dir=${entry##*|}
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi
  ln -snfv "$DOT_DIR/config/$file" "$dir${file##*/}"
done

# Config Deployment complete
result "Config Deployment complete!"
