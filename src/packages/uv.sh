#!/bin/bash
# Package: uv

package_name "uv"

if ! has "uv"; then
  curl -LsSf https://astral.sh/uv/install.sh | UV_NO_MODIFY_PATH=1 sh
  export PATH="$HOME/.local/bin:$PATH"
else
  uv self update
fi

uv --version
uv generate-shell-completion zsh | tee ~/.zsh/completions/_uv >/dev/null
uvx --generate-shell-completion zsh | tee ~/.zsh/completions/_uvx >/dev/null
