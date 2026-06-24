#!/bin/bash
# Config Deployment Script for Darwin.

# main
. "$DOT_DIR/src/utils.sh"

title "Config Deployment start..."

if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the package setup script first."
fi

declare -a SYMLINK_ENTRIES=(
  "docker/$(os_name)/config.json|$HOME/.docker/"
  "git/.gitconfig.local|$HOME/"
  "git/ignore|$HOME/.config/git/"
  "mise/.default-gems|$HOME/"
  "mise/.gemrc|$HOME/"
  "prezto/.zpreztorc|$HOME/"
  "starship/starship.toml|$HOME/.config/"
  "vim/.vimrc|$HOME/"
  "zsh/$(os_name)/.zshrc|$HOME/"
)

for entry in "${SYMLINK_ENTRIES[@]}"; do
  file=${entry%%|*}
  dir=${entry#*|}
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi
  ln -snfv "$DOT_DIR/config/$file" "$dir${file##*/}"
done

# Config Deployment complete
summary_result "Config Deployment complete!"
