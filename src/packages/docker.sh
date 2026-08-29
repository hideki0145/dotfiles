#!/bin/bash
# Package: docker

package_name "docker"

case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
  if ! has "docker"; then
    if ! check_wsl1; then
      sudo apt install -y ca-certificates curl
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
      sudo apt update -qq
      sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      sudo usermod -aG docker "$USER"
      grep </etc/group docker
    else
      skip "docker"
    fi
  fi
  ;;
darwin)
  if ! has_formula "docker"; then
    brew install -y docker
  fi
  if ! has_formula "docker-compose"; then
    brew install -y docker-compose
  fi
  ;;
*) ;;
esac

if has "docker"; then
  docker --version
  docker compose version
fi
