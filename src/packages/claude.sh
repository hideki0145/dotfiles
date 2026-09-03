#!/bin/bash
# Package: claude

package_name "claude"

if ! has "claude"; then
  curl -fsSL https://claude.ai/install.sh | bash
else
  claude update
fi

claude --version
