#!/bin/bash
# Package: uv

package_name "uv"

if ! has "uv"; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # shellcheck source=/dev/null
  source "$HOME/.local/bin/env"
else
  uv self update
fi

uv --version
uv generate-shell-completion zsh | tee ~/.zsh/completions/_uv >/dev/null
uvx --generate-shell-completion zsh | tee ~/.zsh/completions/_uvx >/dev/null
