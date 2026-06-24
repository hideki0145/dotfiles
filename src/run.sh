#!/bin/bash
# Run Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
readonly GITHUB_REPOSITORY="hideki0145/dotfiles"
readonly DOTFILES_ORIGIN_URL="https://github.com/$GITHUB_REPOSITORY.git"
readonly DEFAULT_DOTFILES_BRANCH="main"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
readonly FIRST_RUN="$DOT_DIR/tmp/first_run"

DOTFILES_BRANCH="$DEFAULT_DOTFILES_BRANCH"
RUN_ALL=true
RUN_PACKAGE_UPDATE=false
RUN_PACKAGE_SETUP=false
RUN_DEVKIT_SETUP=false
RUN_CONFIG_DEPLOY=false
while [ "$#" -gt 0 ]; do
  case "$1" in
  --branch)
    if [ "$#" -lt 2 ] || [[ "$2" = -* ]]; then
      echo "--branch requires a value." >&2
      exit 1
    fi
    DOTFILES_BRANCH="$2"
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
  --help | -h)
    cat <<EOF
Usage: $GITHUB_REPOSITORY run.sh [OPTIONS]

Options:
  --all                 Run all setup steps. This is the default.
  --branch BRANCH       Use a specific dotfiles branch. Defaults to main.
  --package-update, -u  Update installed packages.
  --package-setup, -s   Install required packages.
  --devkit-setup, -d    Install development tools.
  --config-deploy, -c   Deploy configuration files.
  --help, -h            Show this help.
EOF
    exit 0
    ;;
  *)
    echo "Unknown argument: $1" >&2
    exit 1
    ;;
  esac
  shift
done
readonly DOTFILES_BRANCH
readonly DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/archive/refs/heads/$DOTFILES_BRANCH.tar.gz"
readonly DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/$DOTFILES_BRANCH/src/utils.sh"

if [ ! -f "$UTILS_SCRIPT" ]; then
  mkdir -p "$DOT_DIR/src"
  if type "curl" >/dev/null 2>&1; then
    curl -fSL "$DOTFILES_UTILS_URL" -o "$UTILS_SCRIPT" ||
      {
        printf "Error: failed to download utils script.\n" 1>&2
        exit 1
      }
  elif type "wget" >/dev/null 2>&1; then
    wget -O "$UTILS_SCRIPT" "$DOTFILES_UTILS_URL" ||
      {
        printf "Error: failed to download utils script.\n" 1>&2
        exit 1
      }
  else
    printf "Error: curl or wget required.\n" 1>&2
    exit 1
  fi
fi
source "$UTILS_SCRIPT"

# shellcheck disable=SC2034
readonly DOTFILES_COLLECT_SUMMARY=true
# shellcheck disable=SC2034
declare -a DOTFILES_SUMMARY_MESSAGES=()

if [ ! -d "$DOT_DIR/.git" ]; then
  exist_first_run=0
  if [ -f "$FIRST_RUN" ]; then
    exist_first_run=1
  fi
  rm -rf "$DOT_DIR"
  if has "git"; then
    download "Clone dotfiles repository ($DOTFILES_BRANCH)..."
    git clone --branch "$DOTFILES_BRANCH" "$DOTFILES_ORIGIN_URL" "$DOT_DIR" ||
      error "failed to clone dotfiles repository branch: $DOTFILES_BRANCH"
  elif has "curl" || has "wget"; then
    download "Download dotfiles repository ($DOTFILES_BRANCH)..."
    mkdir -p "$DOT_DIR/tmp"
    dotfiles_tarball="$DOT_DIR/tmp/dotfiles.tar.gz"
    if has "curl"; then
      curl -fSL "$DOTFILES_TARBALL_URL" -o "$dotfiles_tarball"
    elif has "wget"; then
      wget -O "$dotfiles_tarball" "$DOTFILES_TARBALL_URL"
    fi ||
      error "failed to download dotfiles repository branch: $DOTFILES_BRANCH"
    tar zxf "$dotfiles_tarball" --strip-components=1 -C "$DOT_DIR" ||
      error "failed to download dotfiles repository branch: $DOTFILES_BRANCH"
  else
    error "curl or wget required."
  fi
  if [ $exist_first_run -ne 0 ]; then
    mkdir -p "$DOT_DIR/tmp"
    touch "$FIRST_RUN"
  fi
else
  cd "$DOT_DIR" || exit
  download "Pull dotfiles repository ($DOTFILES_BRANCH)..."
  git fetch origin "$DOTFILES_BRANCH:refs/remotes/origin/$DOTFILES_BRANCH" ||
    error "failed to fetch dotfiles repository branch: $DOTFILES_BRANCH"
  if git show-ref --verify --quiet "refs/heads/$DOTFILES_BRANCH"; then
    git switch "$DOTFILES_BRANCH" ||
      error "failed to switch dotfiles repository branch: $DOTFILES_BRANCH"
  else
    git switch --track -c "$DOTFILES_BRANCH" "origin/$DOTFILES_BRANCH" ||
      error "failed to switch dotfiles repository branch: $DOTFILES_BRANCH"
  fi
  git merge --ff-only "origin/$DOTFILES_BRANCH" ||
    error "failed to merge dotfiles repository branch: $DOTFILES_BRANCH"
fi

PACKAGE_UPDATE_SCRIPT="$DOT_DIR/src/$(os_name)/package_update.sh"
readonly PACKAGE_UPDATE_SCRIPT
PACKAGE_SETUP_SCRIPT="$DOT_DIR/src/$(os_name)/package_setup.sh"
readonly PACKAGE_SETUP_SCRIPT
DEVKIT_SETUP_SCRIPT="$DOT_DIR/src/$(os_name)/devkit_setup.sh"
readonly DEVKIT_SETUP_SCRIPT
CONFIG_DEPLOY_SCRIPT="$DOT_DIR/src/$(os_name)/config_deploy.sh"
readonly CONFIG_DEPLOY_SCRIPT
readonly SCRIPTS=(
  "$PACKAGE_UPDATE_SCRIPT"
  "$PACKAGE_SETUP_SCRIPT"
  "$DEVKIT_SETUP_SCRIPT"
  "$CONFIG_DEPLOY_SCRIPT"
)

for script in "${SCRIPTS[@]}"; do
  if [ ! -f "$script" ]; then
    error "not found: $script"
  fi
done

if [ "$(os_name)" != "darwin" ]; then
  ask_for_sudo_password
fi

run_scripts() {
  for script in "${SCRIPTS[@]}"; do
    source "$script"
  done
}

if $RUN_ALL; then
  run_scripts
else
  if $RUN_PACKAGE_UPDATE; then
    source "$PACKAGE_UPDATE_SCRIPT"
  fi
  if $RUN_PACKAGE_SETUP; then
    source "$PACKAGE_SETUP_SCRIPT"
  fi
  if $RUN_DEVKIT_SETUP; then
    source "$DEVKIT_SETUP_SCRIPT"
  fi
  if $RUN_CONFIG_DEPLOY; then
    source "$CONFIG_DEPLOY_SCRIPT"
  fi
fi

if ! check_gh_auth_status; then
  summary_hint "You are not logged in to GitHub. Please run 'gh auth login'."
fi
if [ -z "$MISE_GITHUB_TOKEN" ]; then
  summary_hint "The environment variable MISE_GITHUB_TOKEN is not set."
fi
print_summary
