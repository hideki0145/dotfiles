#!/bin/bash
# Package Setup Script.

if ! ${DOTFILES_RUNNER:-false}; then
  printf "Error: Please run this script via src/run.sh.\n" 1>&2
  exit 1
fi

# main
# shellcheck source=utils.sh
source "$DOT_DIR/src/utils.sh"
# shellcheck source=/dev/null
source "$DOT_DIR/src/$DOTFILES_OS_NAME/utils.sh"

title "Package Setup start..."

mkdir -p ~/.zsh/completions

case "$DOTFILES_OS_NAME" in
ubuntu)
  PACKAGES=(
    # Required packages
    curl uv
    # CUI packages
    git vim zsh prezto starship tig delta rustup mise yarn claude codex
    # GUI packages
    google-chrome
  )
  ;;
darwin)
  PACKAGES=(
    # Required packages
    homebrew mas uv
    # CUI packages
    git vim zsh prezto starship tig delta rustup mise yarn claude codex
    # GUI packages
    google-chrome homebrew-casks mas-apps
  )
  ;;
*) ;;
esac
readonly PACKAGES

for package in "${PACKAGES[@]}"; do
  # shellcheck source=/dev/null
  source "$DOT_DIR/src/packages/$package.sh"
done

# Package Setup complete
if [ -f "$FIRST_RUN" ]; then
  summary_result "Package Setup complete!"
  summary_description "Please restarting your shell."
else
  touch "$FIRST_RUN"
  summary_result "First Package Setup complete!"
  summary_description "You run it for the first time, please deployment of config, and restarting your shell."
  summary_description "After that, please re-run this script again."
fi
