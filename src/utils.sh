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

# Ask for sudo password upfront.
# For reference, see: https://github.com/alrra/dotfiles/blob/main/src/os/utils.sh#L20
#                     https://gist.github.com/cowboy/3118588
ask_for_sudo_password() {
  sudo -v &> /dev/null
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &> /dev/null &
}

# Check existence of the command.
has() {
  type "$1" > /dev/null 2>&1
  return $?
}

# Print in color text.
# For reference, see: https://github.com/alrra/dotfiles/blob/main/src/os/utils.sh#L218
print_in_color() {
  printf "%b" "$(tput setaf "$2" 2> /dev/null)$1$(tput sgr0 2> /dev/null)"
}
print_in_red() {
  print_in_color "$1" 1
}
print_in_green() {
  print_in_color "$1" 2
}
print_in_yellow() {
  print_in_color "$1" 3
}
print_in_blue() {
  print_in_color "$1" 4
}
print_in_magenta() {
  print_in_color "$1" 5
}
print_in_cyan() {
  print_in_color "$1" 6
}

# Display download message.
download() {
  print_in_blue "⬇ $1\n"
}
# Display title message.
title() {
  print_in_magenta "\n▶ $1\n"
}
# Display package name.
package_name() {
  print_in_cyan "\n***** $1 *****\n"
}
# Display result message.
result() {
  print_in_green "\n✔ $1\n"
}
# Display description message.
description() {
  print_in_green "$1\n"
}
# Display setup skip message.
skip() {
  print_in_yellow "‼ Skip $1 setup.\n"
}
# Display hint message.
hint() {
  print_in_yellow "✎ Hint: $1\n"
}

# Display error message and returns exit code error.
error() {
  print_in_red "✖ $1\n" 1>&2
  exit 1
}

# Check GitHub CLI.
check_gh_auth_status() {
  if ! has "gh" || ! gh auth status &> /dev/null; then
    return 1
  fi
  return 0
}
# Get GitHub repository.
get_github_repository() {
  if check_gh_auth_status; then
    gh api $1
  else
    curl -s "https://api.github.com$1"
  fi
}
