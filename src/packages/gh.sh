#!/bin/bash
# Package: gh

package_name "gh"

setup_mise_tool "gh@latest"

has gh && gh completion -s zsh | tee ~/.zsh/completions/_gh >/dev/null

verify_command --format first_line gh --version
