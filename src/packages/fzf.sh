#!/bin/bash
# Package: fzf

package_name "fzf"

setup_mise_tool "fzf@latest"

verify_command fzf --version
