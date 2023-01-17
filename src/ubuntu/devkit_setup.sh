#!/bin/bash
# Development Kit Setup Script for Ubuntu.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh
. "$DOT_DIR"/src/$(os_name)/utils.sh

readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the setup script first."
fi

sudo -v &> /dev/null
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done &> /dev/null &


# postgresql
echo "***** postgresql *****"
if ! has "psql"; then
  sudo apt install -y curl ca-certificates gnupg
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  sudo apt update
  sudo apt install -y postgresql libpq-dev
  sudo su postgres -c "createuser -s $LOGNAME"
else
  psql --version
fi
echo "**********************"

# redis
echo "***** redis *****"
if ! has "redis-cli"; then
  curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
  sudo apt update
  sudo apt install -y redis
  sudo systemctl enable redis-server.service
else
  redis-cli --version
fi
echo "*****************"

# graphviz
echo "***** graphviz *****"
if ! has "dot"; then
  sudo apt install -y graphviz
else
  dot -V
fi
echo "********************"

# google chrome
echo "***** google chrome *****"
if ! has "google-chrome"; then
  curl -LsS "https://dl.google.com/linux/direct/google-chrome-stable_current_$(dpkg --print-architecture).deb" -o "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  sudo apt install -y "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  rm "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
else
  google-chrome --version
fi
echo "*************************"


# Development Kit Setup complete
echo ""
echo "Development Kit Setup complete!"
echo "Please restarting your shell."
