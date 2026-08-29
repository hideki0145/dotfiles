#!/bin/bash
# Package: postgresql

package_name "postgresql"

case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://www.postgresql.org/download/linux/ubuntu/
  if ! has "psql"; then
    sudo apt install -y curl ca-certificates
    sudo install -d /usr/share/postgresql-common/pgdg
    sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
    sudo tee /etc/apt/sources.list.d/pgdg.sources <<EOF
Types: deb deb-src
URIs: https://apt.postgresql.org/pub/repos/apt
Suites: $(lsb_release -cs)-pgdg
Architectures: $(dpkg --print-architecture)
Components: main
Signed-By: /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
EOF
    sudo apt update -qq
    sudo apt install -y postgresql-client libpq-dev
  fi
  ;;
darwin)
  if ! has_formula "libpq"; then
    brew install -y libpq
  fi
  ;;
*) ;;
esac

psql --version
