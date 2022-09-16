#!/bin/bash
# Utilities Script.

# Check OS.
os_name() {
  local os=""
  case "$(uname -s)" in
    Linux)
      if [ -f "/etc/os-release" ]; then
        os="$(. /etc/os-release; printf "%s" "$ID")"
      else
        os="linux"
      fi
      ;;
    Darwin)
      os="darwin"
      ;;
    *)
      os="$(uname -s | tr '[:upper:]' '[:lower:]')"
      ;;
  esac
  printf "%s" "$os"
}
os_version() {
  local version=""
  case "$(uname -s)" in
    Linux)
      if [ -f "/etc/os-release" ]; then
        version="$(. /etc/os-release; printf "%s" "$VERSION_ID")"
      fi
      ;;
    Darwin)
      version="$(sw_vers -productVersion)"
      ;;
    *)
      ;;
  esac
  printf "%s" "$version"
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
