#!/bin/bash
# Package: lazydocker

package_name "lazydocker"

setup_mise_tool "lazydocker@latest"

verify_command --format first_line lazydocker --version
