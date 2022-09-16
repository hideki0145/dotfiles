#!/bin/bash
# Setup Script for Darwin.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh


# homebrew
echo "***** homebrew *****"
if ! has "brew"; then
  xcode-select --install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew --version
fi
echo "********************"


# Setup complete
readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
echo ""
if [ -f "$FIRST_RUN" ]; then
  echo "Setup complete!"
  echo "Please restarting your shell."
else
  touch "$FIRST_RUN"
  echo "First setup complete!"
  echo "You run it for the first time, please deployment of dotfiles, and restarting your shell."
  echo "After that, please re-run this script again."
fi
