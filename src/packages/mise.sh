#!/bin/bash
# Package: mise

package_name "mise"

if ! has "mise"; then
  curl https://mise.run | sh
  echo '' >>~/.bashrc
  # shellcheck disable=SC2016
  echo 'eval "$(~/.local/bin/mise activate bash)"' >>~/.bashrc
  eval "$(~/.local/bin/mise activate bash)"
else
  mise self-update -y --no-plugins
fi

mise --version
mise completion zsh | tee ~/.zsh/completions/_mise >/dev/null
