#!/bin/bash
# Utilities Script for Darwin.

# Check homebrew formulae.
has_cask() {
  if [ -z "`brew list --cask -1 | grep $1`" ]; then
    return 1
  fi
  return 0
}
cask_version() {
  brew list --cask --versions | grep "$1"
}
