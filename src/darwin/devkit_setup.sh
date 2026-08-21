#!/bin/bash
# Development Kit Setup Script for Darwin.

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
package_name "postgresql"
if ! has_formula "libpq"; then
  brew install -y libpq
else
  psql --version
fi

# sqlite3
package_name "sqlite3"
if ! has_formula "sqlite"; then
  brew install -y sqlite
else
  sqlite3 --version
fi

# redis
# For reference, see: https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/install-redis-cli/
package_name "redis"
REDIS_CLI_VERSION=$(curl -fsSL https://packages.redis.io/redis-cli/stable | tr -d ' \t\r\n')
if ! has "redis-cli" || [ ! "$REDIS_CLI_VERSION" = "$(redis-cli --version | sed -n 's/^redis-cli \([^[:space:]]*\).*$/\1/p')" ]; then
  curl -fsSL https://packages.redis.io/redis-cli/install.sh | sh
fi
redis-cli --version

# gh
package_name "gh"
if ! has_formula "gh"; then
  brew install -y gh
else
  gh --version
fi

# lazygit
package_name "lazygit"
if ! has_formula "lazygit"; then
  brew install -y lazygit
else
  lazygit --version
fi

# lazydocker
package_name "lazydocker"
if ! has_formula "lazydocker"; then
  brew install -y lazydocker
else
  lazydocker --version
fi

# docker
package_name "docker"
if ! has_formula "docker"; then
  brew install -y docker
  brew install -y docker-compose
else
  docker --version
  docker compose version
  if ! docker compose ls --all | grep -q dotfiles; then
    docker compose -f "$DOT_DIR/config/docker/compose.yaml" up -d
  fi
fi

# lima
package_name "lima"
if ! has_formula "lima"; then
  brew install -y lima
  limactl start --name=docker --vm-type=vz --mount-type=virtiofs --network=vzNAT --mount-writable --rosetta template:docker
  limactl start-at-login docker
  docker context create lima-docker --docker "host=unix:///$HOME/.lima/docker/sock/docker.sock"
  docker context use lima-docker
else
  limactl --version
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
