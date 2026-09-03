#!/bin/bash
# Install Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
readonly DOTFILES_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
readonly FIRST_RUN="$DOTFILES_STATE_DIR/first_run"
readonly SKIP_HOMEBREW_CASK="$DOTFILES_STATE_DIR/skip_homebrew_cask"
readonly SKIP_MAS="$DOTFILES_STATE_DIR/skip_mas"

RUN_ALL=true
RUN_PACKAGE_UPDATE=false
RUN_PACKAGE_SETUP=false
RUN_DEVKIT_SETUP=false
RUN_CONFIG_DEPLOY=false
CREATE_SKIP_HOMEBREW_CASK=false
CREATE_SKIP_MAS=false
while [ "$#" -gt 0 ]; do
  case "$1" in
  --branch)
    if [ "$#" -lt 2 ] || [[ "$2" = -* ]]; then
      printf "Error: --branch requires a value.\n" 1>&2
      exit 1
    fi
    shift
    ;;
  --all)
    RUN_ALL=true
    RUN_PACKAGE_UPDATE=false
    RUN_PACKAGE_SETUP=false
    RUN_DEVKIT_SETUP=false
    RUN_CONFIG_DEPLOY=false
    ;;
  --package-update | -u)
    RUN_ALL=false
    RUN_PACKAGE_UPDATE=true
    ;;
  --package-setup | -s)
    RUN_ALL=false
    RUN_PACKAGE_SETUP=true
    ;;
  --devkit-setup | -d)
    RUN_ALL=false
    RUN_DEVKIT_SETUP=true
    ;;
  --config-deploy | -c)
    RUN_ALL=false
    RUN_CONFIG_DEPLOY=true
    ;;
  --skip-homebrew-cask)
    CREATE_SKIP_HOMEBREW_CASK=true
    ;;
  --skip-mas)
    CREATE_SKIP_MAS=true
    ;;
  --help | -h)
    cat <<EOF
Usage: $DOT_DIR/src/install.sh [OPTIONS]

Options:
  --all                 Run all setup steps. This is the default.
  --branch BRANCH       Handled by run.sh. Has no effect when running install.sh directly.
  --package-update, -u  Update installed packages.
  --package-setup, -s   Install required packages.
  --devkit-setup, -d    Install development tools.
  --config-deploy, -c   Deploy configuration files.
  --skip-homebrew-cask  Skip Homebrew cask installation.
  --skip-mas            Skip mas and Mac App Store apps installation.
  --help, -h            Show this help.
EOF
    exit 0
    ;;
  *)
    printf "Error: Unknown argument: %s\n" "$1" 1>&2
    exit 1
    ;;
  esac
  shift
done

if [ ! -f "$UTILS_SCRIPT" ]; then
  printf "Error: Not found: %s\n" "$UTILS_SCRIPT" 1>&2
  exit 1
fi
# shellcheck source=utils.sh
source "$UTILS_SCRIPT"

mkdir -p "$DOTFILES_STATE_DIR" || error "Failed to create dotfiles state directory."

readonly DOTFILES_RUNNER=true
readonly DOTFILES_COLLECT_SUMMARY=true
declare -a DOTFILES_SUMMARY_MESSAGES=()
trap print_summary EXIT

if $CREATE_SKIP_HOMEBREW_CASK; then
  touch "$SKIP_HOMEBREW_CASK"
fi
if $CREATE_SKIP_MAS; then
  touch "$SKIP_MAS"
fi

ensure_os_support
DOTFILES_OS_NAME="$(os_name)"
readonly DOTFILES_OS_NAME
PACKAGE_UPDATE_SCRIPT="$DOT_DIR/src/package_update.sh"
readonly PACKAGE_UPDATE_SCRIPT
PACKAGE_SETUP_SCRIPT="$DOT_DIR/src/package_setup.sh"
readonly PACKAGE_SETUP_SCRIPT
DEVKIT_SETUP_SCRIPT="$DOT_DIR/src/devkit_setup.sh"
readonly DEVKIT_SETUP_SCRIPT
CONFIG_DEPLOY_SCRIPT="$DOT_DIR/src/config_deploy.sh"
readonly CONFIG_DEPLOY_SCRIPT
readonly SCRIPTS=(
  "$PACKAGE_UPDATE_SCRIPT"
  "$PACKAGE_SETUP_SCRIPT"
  "$DEVKIT_SETUP_SCRIPT"
  "$CONFIG_DEPLOY_SCRIPT"
)

for script in "${SCRIPTS[@]}"; do
  if [ ! -f "$script" ]; then
    error "Not found: $script"
  fi
done

if [ "$DOTFILES_OS_NAME" != "darwin" ]; then
  ask_for_sudo_password
fi

run_scripts() {
  for script in "${SCRIPTS[@]}"; do
    # shellcheck source=/dev/null
    source "$script"
  done
}

if $RUN_ALL; then
  run_scripts
else
  if $RUN_PACKAGE_UPDATE; then
    # shellcheck source=package_update.sh
    source "$PACKAGE_UPDATE_SCRIPT"
  fi
  if $RUN_PACKAGE_SETUP; then
    # shellcheck source=package_setup.sh
    source "$PACKAGE_SETUP_SCRIPT"
  fi
  if $RUN_DEVKIT_SETUP; then
    # shellcheck source=devkit_setup.sh
    source "$DEVKIT_SETUP_SCRIPT"
  fi
  if $RUN_CONFIG_DEPLOY; then
    # shellcheck source=config_deploy.sh
    source "$CONFIG_DEPLOY_SCRIPT"
  fi
fi

if ! check_gh_auth_status; then
  summary_hint "You are not logged in to GitHub. Please run 'gh auth login'."
fi
if [ -z "$MISE_GITHUB_TOKEN" ]; then
  summary_hint "The environment variable MISE_GITHUB_TOKEN is not set."
fi
