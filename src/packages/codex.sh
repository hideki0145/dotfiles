#!/bin/bash
# Package: codex

package_name "codex"

if ! has "codex"; then
  curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
else
  codex update
fi

codex --version
