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

# sqlite3
package_name "sqlite3"
if ! has "sqlite3"; then
  sudo apt install -y sqlite3 libsqlite3-dev
else
  sqlite3 --version
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

# lazygit
package_name "lazygit"
compose_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[\d.]+')
if ! has "lazygit" || [ ! "$compose_version" = "$(lazygit --version | grep -Po 'version=\K[\d.]+')" ]; then
  curl -LsS "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${compose_version}_$(uname -s)_$(uname -m).tar.gz" -o "$DOT_DIR/tmp/lazygit.tar.gz"
  sudo tar xf "$DOT_DIR/tmp/lazygit.tar.gz" -C /usr/bin lazygit
fi
lazygit --version

# lazydocker
package_name "lazydocker"
compose_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[\d.]+')
if ! has "lazydocker" || [ ! "$compose_version" = "$(lazydocker --version | grep -Po 'Version: \K[\d.]+')" ]; then
  curl -LsS "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${compose_version}_$(uname -s)_$(uname -m).tar.gz" -o "$DOT_DIR/tmp/lazydocker.tar.gz"
  sudo tar xf "$DOT_DIR/tmp/lazydocker.tar.gz" -C /usr/bin lazydocker
fi
lazydocker --version

# docker
package_name "docker"
if ! has "docker"; then
  if ! check_wsl1; then
    sudo apt install -y ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
    cat /etc/group | grep docker
    sudo mkdir -p /usr/local/lib/docker/cli-plugins/
    compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\Kv[\d.]+')
    sudo curl -SL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
  else
    skip "docker"
  fi
else
  docker --version
  docker compose version
fi


# Development Kit Setup complete
result "Development Kit Setup complete!"
description "Please restarting your shell."
