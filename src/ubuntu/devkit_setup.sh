#!/bin/bash
# Development Kit Setup Script for Ubuntu.

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
if ! has "psql"; then
  sudo apt install -y curl ca-certificates gnupg
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  sudo apt update
  sudo apt install -y postgresql libpq-dev
  sudo -u postgres createuser -s $LOGNAME
else
  psql --version
fi

# redis
package_name "redis"
if ! has "redis-cli"; then
  curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
  sudo apt update
  sudo apt install -y redis
  sudo systemctl enable redis-server.service
else
  redis-cli --version
fi

# graphviz
package_name "graphviz"
if ! has "dot"; then
  sudo apt install -y graphviz
else
  dot -V
fi

# google chrome
package_name "google chrome"
if ! has "google-chrome"; then
  curl -LsS "https://dl.google.com/linux/direct/google-chrome-stable_current_$(dpkg --print-architecture).deb" -o "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  sudo apt install -y "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  rm "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
else
  google-chrome --version
fi


# Development Kit Setup complete
result "Development Kit Setup complete!"
description "Please restarting your shell."
