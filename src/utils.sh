#!/bin/bash
# Utilities Script.

# Check OS.
os_ubuntu() {
  if [ ! "$(lsb_release -cs)" = "$1" ]; then
    return 1
  fi
  return 0
}

# Check WSL.
check_wsl1_or_wsl2() {
  if [ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    return 1
  fi
  return 0
}
check_wsl1() {
  if ! check_wsl1_or_wsl2 || check_wsl2; then
    return 1
  fi
  return 0
}
check_wsl2() {
  if ! check_wsl1_or_wsl2; then
    return 1
  fi
  grep --quiet Hyper-V /proc/interrupts
  return $?
}

# Check existence of the command.
has() {
  type "$1" > /dev/null 2>&1
  return $?
}

# Display setup skip message.
skip() {
  echo "Skip $1 setup."
}

# Display error message and returns exit code error.
error() {
  echo "$1" 1>&2
  exit 1
}

# Setup of packages.
setup() {
  bash "$DOT_DIR"/src/setup.sh
  return 0
}

# Deployment of dotfiles.
deploy() {
  bash "$DOT_DIR"/src/deploy.sh
  return 0
}
