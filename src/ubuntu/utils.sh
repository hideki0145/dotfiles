#!/bin/bash
# Utilities Script for Ubuntu.

# Install Debian packages.
apt_install() {
  sudo apt install -y -qq "$@"
}
# Update Debian package lists.
apt_update() {
  sudo apt update -qq
}

# Check Debian packages.
has_package() {
  dpkg-query -W -f='${db:Status-Status}\n' "$1" 2>/dev/null | grep -qx "installed"
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
