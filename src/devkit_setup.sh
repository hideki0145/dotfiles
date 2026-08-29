#!/bin/bash
# Development Kit Setup Script.

if ! ${DOTFILES_RUNNER:-false}; then
  printf "Error: Please run this script via src/run.sh.\n" 1>&2
  exit 1
fi

# main
# shellcheck source=utils.sh
source "$DOT_DIR/src/utils.sh"
# shellcheck source=/dev/null
source "$DOT_DIR/src/$DOTFILES_OS_NAME/utils.sh"

title "Development Kit Setup start..."

if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the package setup script first."
fi

case "$DOTFILES_OS_NAME" in
ubuntu)
  DEVKIT_PACKAGES=(
    # CUI packages
    postgresql sqlite3 redis gh lazygit lazydocker docker ansible
    # Local development services
    docker-services
  )
  ;;
darwin)
  DEVKIT_PACKAGES=(
    # CUI packages
    postgresql sqlite3 redis gh lazygit lazydocker docker lima ansible
    # Local development services
    docker-services
  )
  ;;
*) ;;
esac
readonly DEVKIT_PACKAGES

for package in "${DEVKIT_PACKAGES[@]}"; do
  # shellcheck source=/dev/null
  source "$DOT_DIR/src/packages/$package.sh"
done

# Development Kit Setup complete
summary_result "Development Kit Setup complete!"
summary_description "Please restart your shell."
