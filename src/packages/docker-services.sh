#!/bin/bash
# Package: docker-services

package_name "docker-services"

if ! has "docker"; then
  skip "docker-services"
  return 0
fi

if ! docker info >/dev/null 2>&1; then
  skip "docker-services"
  summary_hint "Docker daemon is not available. Please restart your shell and re-run this script."
  return 0
fi

COMPOSE_FILE="$DOT_DIR/config/docker/compose.yaml"
if ! docker compose ls --all | grep -q dotfiles; then
  docker compose -f "$COMPOSE_FILE" up -d
fi

docker compose -f "$COMPOSE_FILE" ps
