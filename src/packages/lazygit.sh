#!/bin/bash
# Package: lazygit

package_name "lazygit"

setup_mise_tool "lazygit@latest"

verify_command lazygit --version
