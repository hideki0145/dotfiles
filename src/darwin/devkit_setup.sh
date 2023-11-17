#!/bin/bash
# Development Kit Setup Script for Darwin.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh
. "$DOT_DIR"/src/$(os_name)/utils.sh

title "Development Kit Setup start..."

readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the package setup script first."
fi


# CUI packages
# postgresql
package_name "postgresql"
if ! has_formula "postgresql@16"; then
  brew install postgresql@16
  brew services start postgresql@16
else
  psql --version
fi

# redis
package_name "redis"
if ! has_formula "redis"; then
  brew install redis
  brew services start redis
else
  redis-cli --version
fi

# graphviz
package_name "graphviz"
if ! has_formula "graphviz"; then
  brew install graphviz
else
  dot -V
fi


# Development Kit Setup complete
result "Development Kit Setup complete!"
description "Please restarting your shell."
