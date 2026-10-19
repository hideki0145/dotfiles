#!/bin/bash
# Package: yarn

package_name "yarn"

if ! has "yarn"; then
  if has "corepack"; then
    corepack enable
  else
    skip "yarn"
  fi
fi

if has "yarn"; then
  verify_command yarn --version
fi
