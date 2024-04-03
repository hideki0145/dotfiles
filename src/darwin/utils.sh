#!/bin/bash
# Utilities Script for Darwin.

# Check homebrew formulae.
has_formula() {
  if [ -z "`brew list --formula -1 | grep ^$1$`" ]; then
    return 1
  fi
  return 0
}
has_cask() {
  if [ -z "`brew list --cask -1 | grep ^$1$`" ]; then
    return 1
  fi
  return 0
}
cask_version() {
  brew list --cask --versions | grep "^$1 "
}

# Check mas apps.
has_mas() {
  if [ -z "`mas list | grep \"^$1 \"`" ]; then
    return 1
  fi
  return 0
}
mas_version() {
  mas list | grep "^$1 "
}

# Check information property list.
plist_version() {
  /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$1/Info.plist"
}
