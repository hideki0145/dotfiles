#!/bin/bash
# Package: jq

package_name "jq"

setup_mise_tool "jq@latest"

verify_command jq --version
