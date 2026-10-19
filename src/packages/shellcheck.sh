#!/bin/bash
# Package: shellcheck

package_name "shellcheck"

setup_mise_tool "shellcheck@latest"

verify_command --format first_two_lines shellcheck --version
