#!/bin/bash
# Utilities Script for Darwin.

# Check homebrew formulae.
has_formula() {
  if ! brew list --formula -1 | grep -q "^$1$"; then
    return 1
  fi
  return 0
}
has_cask() {
  if ! brew list --cask -1 | grep -q "^$1$"; then
    return 1
  fi
  return 0
}
cask_version() {
  brew list --cask --versions | grep "^$1 "
}

# Check mas apps.
has_mas() {
  if ! mas list | grep -q "^ *$1 "; then
    return 1
  fi
  return 0
}
mas_version() {
  mas list | grep "^ *$1 "
}

# Check information property list.
plist_version() {
  /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$1/Info.plist"
}
