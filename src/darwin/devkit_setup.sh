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
  rm -rf $(brew --prefix)/var/postgresql@16
  initdb --locale=ja_JP.UTF-8 -E UTF-8 $(brew --prefix)/var/postgresql@16
  brew services start postgresql@16
else
  psql --version
fi

# sqlite3
package_name "sqlite3"
if ! has_formula "sqlite"; then
  brew install sqlite
else
  sqlite3 --version
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

# gh
package_name "gh"
if ! has_formula "gh"; then
  brew install gh
else
  gh --version
fi

# lazygit
package_name "lazygit"
if ! has_formula "lazygit"; then
  brew install jesseduffield/lazygit/lazygit
else
  lazygit --version
fi

# lazydocker
package_name "lazydocker"
if ! has_formula "lazydocker"; then
  brew install jesseduffield/lazydocker/lazydocker
else
  lazydocker --version
fi

# docker
package_name "docker"
if ! has_formula "docker"; then
  brew install docker
  brew install docker-compose
else
  docker --version
  docker compose version
fi
if [ ! -d "$HOME/.docker" ]; then
  mkdir "$HOME/.docker"
fi
ln -snfv "$DOT_DIR/config/docker/darwin/config.json" "$HOME/.docker/config.json"

# lima
package_name "lima"
if ! has_formula "lima"; then
  brew install lima
  limactl start --name=docker --vm-type=vz --mount-type=virtiofs --network=vzNAT --mount-writable --rosetta template://docker
  limactl start-at-login docker
  docker context create lima-docker --docker "host=unix:///$HOME/.lima/docker/sock/docker.sock"
  docker context use lima-docker
else
  limactl --version
fi


# Development Kit Setup complete
result "Development Kit Setup complete!"
description "Please restarting your shell."
