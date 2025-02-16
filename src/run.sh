#!/bin/bash
# Run Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
readonly GITHUB_REPOSITORY="hideki0145/dotfiles"
readonly DOTFILES_ORIGIN_URL="https://github.com/$GITHUB_REPOSITORY.git"
readonly DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/archive/main.tar.gz"
readonly DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/main/src/utils.sh"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
readonly FIRST_RUN="$DOT_DIR/tmp/first_run"

if [ ! -f "$UTILS_SCRIPT" ]; then
  mkdir -p "$DOT_DIR/src"
  if type "curl" >/dev/null 2>&1; then
    curl -fSL "$DOTFILES_UTILS_URL" -o "$UTILS_SCRIPT"
  elif type "wget" >/dev/null 2>&1; then
    wget -O "$UTILS_SCRIPT" "$DOTFILES_UTILS_URL"
  else
    error "curl or wget required."
  fi
fi
. "$UTILS_SCRIPT"

if [ ! -d "$DOT_DIR/.git" ]; then
  exist_first_run=0
  if [ -f "$FIRST_RUN" ]; then
    exist_first_run=1
  fi
  rm -rf "$DOT_DIR"
  if has "git"; then
    download "Clone dotfiles repository..."
    git clone "$DOTFILES_ORIGIN_URL" "$DOT_DIR"
  elif has "curl" || has "wget"; then
    download "Download dotfiles repository..."
    if has "curl"; then
      curl -fSL "$DOTFILES_TARBALL_URL"
    elif has "wget"; then
      wget -O- "$DOTFILES_TARBALL_URL"
    fi | tar zxv
    mv -f dotfiles-main "$DOT_DIR"
  else
    error "curl or wget required."
  fi
  if [ $exist_first_run -ne 0 ]; then
    mkdir -p "$DOT_DIR/tmp"
    touch "$FIRST_RUN"
  fi
else
  cd "$DOT_DIR" || exit
  download "Pull dotfiles repository..."
  git pull
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

all_flag=true
while getopts usdc-: opt; do
  all_flag=false
  optarg="$OPTARG"
  if [[ "$opt" = - ]]; then
    opt="-${OPTARG%%=*}"
    optarg="${OPTARG/${OPTARG%%=*}/}"
    optarg="${optarg#=}"
    if [[ -z "$optarg" ]] && [[ ! "${!OPTIND}" = -* ]]; then
      optarg="${!OPTIND}"
      shift
    fi
  fi

  case "-$opt" in
  --all)
    run_scripts
    ;;
  -u | --package-update)
    source "$PACKAGE_UPDATE_SCRIPT"
    ;;
  -s | --package-setup)
    source "$PACKAGE_SETUP_SCRIPT"
    ;;
  -d | --devkit-setup)
    source "$DEVKIT_SETUP_SCRIPT"
    ;;
  -c | --config-deploy)
    source "$CONFIG_DEPLOY_SCRIPT"
    ;;
  -*)
    error "invalid option ${opt#-}."
    ;;
  esac
done
if $all_flag; then
  run_scripts
fi

if ! check_gh_auth_status; then
  hint "You are not logged in to GitHub. Please run 'gh auth login'."
fi
if [ -z "$MISE_GITHUB_TOKEN" ]; then
  hint "The environment variable MISE_GITHUB_TOKEN is not set."
fi
