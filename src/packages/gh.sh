#!/bin/bash
# Package: gh

package_name "gh"

setup_mise_tool "gh@latest"

gh completion -s zsh | tee ~/.zsh/completions/_gh >/dev/null
