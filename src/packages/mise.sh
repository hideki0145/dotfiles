#!/bin/bash
# Package: mise

package_name "mise"

# For reference, see: https://mise.jdx.dev/installing-mise.html
if ! has "mise"; then
  curl -fsSL https://mise.run | sh
  eval "$(~/.local/bin/mise activate bash)"
else
  mise self-update -y --no-plugins
fi

mise completion zsh | tee ~/.zsh/completions/_mise >/dev/null

verify_command mise version --quiet
