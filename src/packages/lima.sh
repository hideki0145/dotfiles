#!/bin/bash
# Package: lima (darwin only)

case "$DOTFILES_OS_NAME" in
darwin) ;;
*) return 0 ;;
esac

package_name "lima"

if ! has_formula "lima"; then
  brew install -y lima
  limactl start --name=docker --vm-type=vz --mount-type=virtiofs --network=vzNAT --mount-writable --rosetta template:docker
  limactl autostart enable docker
  docker context create lima-docker --docker "host=unix://$HOME/.lima/docker/sock/docker.sock"
  docker context use lima-docker
fi

limactl --version
