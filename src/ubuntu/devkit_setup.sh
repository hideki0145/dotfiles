#!/bin/bash
# Development Kit Setup Script for Ubuntu.

if ! ${DOTFILES_RUNNER:-false}; then
  printf "Error: Please run this script via src/run.sh.\n" 1>&2
  exit 1
fi

# main
source "$DOT_DIR/src/utils.sh"
source "$DOT_DIR/src/$DOTFILES_OS_NAME/utils.sh"

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

# gh
# For reference, see: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
package_name "gh"
if ! has "gh"; then
  type -p wget >/dev/null || (sudo apt update && sudo apt install -y wget)
  sudo mkdir -p -m 755 /etc/apt/keyrings
  out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
  sudo cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt update
  sudo apt install -y gh
else
  gh --version
fi

# lazygit
# For reference, see: https://github.com/jesseduffield/lazygit?tab=readme-ov-file#debian-and-ubuntu
package_name "lazygit"
LAZYGIT_VERSION=$(get_github_latest_version "jesseduffield/lazygit")
if ! has "lazygit" || [ ! "$LAZYGIT_VERSION" = "$(lazygit --version | sed -n 's/^.*, version=\([^,[:space:]]*\).*$/\1/p')" ]; then
  LAZYGIT_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
  curl -LsSo "$DOT_DIR/tmp/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_$(uname -s)_${LAZYGIT_ARCH}.tar.gz"
  tar xf "$DOT_DIR/tmp/lazygit.tar.gz" -C "$DOT_DIR/tmp"
  sudo install "$DOT_DIR/tmp/lazygit" -D -t /usr/local/bin/
fi
lazygit --version

# lazydocker
# For reference, see: https://github.com/jesseduffield/lazydocker?tab=readme-ov-file#binary-release-linuxosxwindows
package_name "lazydocker"
LAZYDOCKER_VERSION=$(get_github_latest_version "jesseduffield/lazydocker")
if ! has "lazydocker" || [ ! "$LAZYDOCKER_VERSION" = "$(lazydocker --version | sed -n 's/^Version: \([^[:space:]]*\).*$/\1/p')" ]; then
  LAZYDOCKER_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
  curl -LsSo "$DOT_DIR/tmp/lazydocker.tar.gz" "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_$(uname -s)_${LAZYDOCKER_ARCH}.tar.gz"
  tar xf "$DOT_DIR/tmp/lazydocker.tar.gz" -C "$DOT_DIR/tmp"
  sudo install "$DOT_DIR/tmp/lazydocker" -D -t /usr/local/bin/
fi
lazydocker --version

# docker
# For reference, see: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
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

# ansible
# For reference, see: https://docs.astral.sh/uv/guides/tools/#installing-tools
package_name "ansible"
if ! has "ansible"; then
  uv tool install --with-executables-from ansible-core,ansible-lint ansible
else
  ansible --version
fi

# Development Kit Setup complete
summary_result "Development Kit Setup complete!"
summary_description "Please restarting your shell."
