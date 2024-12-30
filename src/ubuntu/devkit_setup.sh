#!/bin/bash
# Development Kit Setup Script for Ubuntu.

# main
. "$DOT_DIR/src/utils.sh"
. "$DOT_DIR/src/$(os_name)/utils.sh"

title "Development Kit Setup start..."

if [ ! -f "$FIRST_RUN" ]; then
  error "Please run the package setup script first."
fi

# CUI packages
# postgresql
# For reference, see: https://www.postgresql.org/download/linux/ubuntu/
package_name "postgresql"
if ! has "psql"; then
  sudo apt install -y curl ca-certificates
  sudo install -d /usr/share/postgresql-common/pgdg
  sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
  sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  sudo apt update
  sudo apt install -y postgresql-client libpq-dev
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
# For reference, see: https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/install-redis-on-linux/
package_name "redis"
if ! has "redis-cli"; then
  sudo apt install -y lsb-release curl gpg
  curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
  sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
  sudo apt update
  sudo apt install -y redis-tools
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

# gh
package_name "gh"
if ! has "gh"; then
  type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)
  sudo mkdir -p -m 755 /etc/apt/keyrings
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt update
  sudo apt install -y gh
else
  gh --version
fi
gh completion -s zsh | sudo tee /usr/local/share/zsh/site-functions/_gh >/dev/null

# lazygit
package_name "lazygit"
package_version=$(get_github_repository "/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name":\s*"v\K[\d.]+')
if ! has "lazygit" || [ ! "$package_version" = "$(lazygit --version | grep -Po 'version=\K[\d.]+')" ]; then
  curl -LsS "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${package_version}_$(uname -s)_$(uname -m).tar.gz" -o "$DOT_DIR/tmp/lazygit.tar.gz"
  sudo tar xf "$DOT_DIR/tmp/lazygit.tar.gz" -C /usr/bin lazygit
fi
lazygit --version

# lazydocker
package_name "lazydocker"
package_version=$(get_github_repository "/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name":\s*"v\K[\d.]+')
if ! has "lazydocker" || [ ! "$package_version" = "$(lazydocker --version | grep -Po 'Version: \K[\d.]+')" ]; then
  curl -LsS "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${package_version}_$(uname -s)_$(uname -m).tar.gz" -o "$DOT_DIR/tmp/lazydocker.tar.gz"
  sudo tar xf "$DOT_DIR/tmp/lazydocker.tar.gz" -C /usr/bin lazydocker
fi
lazydocker --version

# docker
package_name "docker"
if ! has "docker"; then
  if ! check_wsl1; then
    sudo apt install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER"
    grep </etc/group docker
  else
    skip "docker"
  fi
else
  docker --version
  docker compose version
  if ! docker compose ls --all | grep -q dotfiles; then
    docker compose -f "$DOT_DIR/config/docker/compose.yaml" up -d
  fi
fi

# Development Kit Setup complete
result "Development Kit Setup complete!"
description "Please restarting your shell."
