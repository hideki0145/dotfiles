#!/bin/bash
# Package: redis

package_name "redis"

# For reference, see: https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/install-redis-cli/
REDIS_CLI_VERSION=$(curl -fsSL https://packages.redis.io/redis-cli/stable | tr -d ' \t\r\n')
if ! has "redis-cli" || [ ! "$REDIS_CLI_VERSION" = "$(redis-cli --version | sed -n 's/^redis-cli \([^[:space:]]*\).*$/\1/p')" ]; then
  curl -fsSL https://packages.redis.io/redis-cli/install.sh | sh
fi

redis-cli --version
