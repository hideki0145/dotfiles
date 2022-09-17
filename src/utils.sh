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
