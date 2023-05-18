#!/bin/bash
# Development Kit Setup Script for Darwin.
echo ""
echo "Development Kit Setup start..."
echo ""

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh
. "$DOT_DIR"/src/$(os_name)/utils.sh

readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the setup script first."
fi


# CUI packages
# postgresql
echo "***** postgresql *****"
if ! has_formula "postgresql@15"; then
  brew install postgresql@15
  brew services start postgresql@15
else
  psql --version
fi

# redis
echo "***** redis *****"
if ! has_formula "redis"; then
  brew install redis
  brew services start redis
else
  redis-cli --version
fi

# graphviz
echo "***** graphviz *****"
if ! has_formula "graphviz"; then
  brew install graphviz
else
  dot -V
fi


# Development Kit Setup complete
echo ""
echo "Development Kit Setup complete!"
echo "Please restarting your shell."
