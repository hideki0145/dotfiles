#!/bin/bash
# Config Deployment Script.

if ! ${DOTFILES_RUNNER:-false}; then
  printf "Error: Please run this script via src/run.sh.\n" 1>&2
  exit 1
fi

# main
# shellcheck source=utils.sh
source "$DOT_DIR/src/utils.sh"

title "Config Deployment start..."

if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the package setup script first."
fi

declare -a SYMLINK_ENTRIES=(
  "git/.gitconfig.local|$HOME/"
  "git/ignore|$HOME/.config/git/"
  "mise/.default-gems|$HOME/"
  "mise/.gemrc|$HOME/"
  "prezto/.zpreztorc|$HOME/"
  "starship/starship.toml|$HOME/.config/"
  "vim/.vimrc|$HOME/"
  "zsh/$DOTFILES_OS_NAME/.zshrc|$HOME/"
)

case "$DOTFILES_OS_NAME" in
ubuntu)
  ;;
darwin)
  SYMLINK_ENTRIES+=(
    "docker/$DOTFILES_OS_NAME/config.json|$HOME/.docker/"
  )
  ;;
*) ;;
esac
readonly SYMLINK_ENTRIES

for entry in "${SYMLINK_ENTRIES[@]}"; do
  file=${entry%%|*}
  dir=${entry#*|}
  target="$dir${file##*/}"
  mkdir -p "$dir"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
    hint "Backed up existing '$target'."
  fi
  ln -snfv "$DOT_DIR/config/$file" "$target"
done

# Config Deployment complete
summary_result "Config Deployment complete!"
