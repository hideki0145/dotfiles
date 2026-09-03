#!/bin/bash
# Package: redis

package_name "redis"

# For reference, see: https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/install-redis-cli/
require_url_latest_version "https://packages.redis.io/redis-cli/stable" REDIS_CLI_VERSION "redis-cli" || return 0
if ! has "redis-cli" || [ ! "$REDIS_CLI_VERSION" = "$(redis-cli --version | sed -n 's/^redis-cli \([^[:space:]]*\).*$/\1/p')" ]; then
  curl -fsSL https://packages.redis.io/redis-cli/install.sh | sh
fi

redis-cli --version
