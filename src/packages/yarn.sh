#!/bin/bash
# Package: yarn

package_name "yarn"

if ! has "yarn"; then
  if ! has "corepack"; then
    skip "yarn"
    return 0
  fi
  corepack enable
fi

verify_command yarn --version
