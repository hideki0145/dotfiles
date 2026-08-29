#!/bin/bash
# Package: ansible

package_name "ansible"

# For reference, see: https://docs.astral.sh/uv/guides/tools/#installing-tools
if ! has "ansible"; then
  uv tool install --with-executables-from ansible-core,ansible-lint ansible
fi

ansible --version
