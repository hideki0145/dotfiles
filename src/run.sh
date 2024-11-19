#!/bin/bash
# Run Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
readonly GITHUB_REPOSITORY="hideki0145/dotfiles"
readonly DOTFILES_ORIGIN_URL="https://github.com/$GITHUB_REPOSITORY.git"
readonly DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/archive/main.tar.gz"
readonly DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/main/src/utils.sh"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"

if [ ! -f "$UTILS_SCRIPT" ]; then
  mkdir -p "$DOT_DIR/src"
  curl -SL "$DOTFILES_UTILS_URL" -o "$UTILS_SCRIPT"
fi
. "$UTILS_SCRIPT"

if [ ! -d "$DOT_DIR/.git" ]; then
  readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
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
      curl -L "$DOTFILES_TARBALL_URL"
    elif has "wget"; then
      wget -O - "$DOTFILES_TARBALL_URL"
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
  cd "$DOT_DIR"
  download "Pull dotfiles repository..."
  git pull
fi

readonly PACKAGE_UPDATE_SCRIPT="$DOT_DIR/src/$(os_name)/package_update.sh"
readonly PACKAGE_SETUP_SCRIPT="$DOT_DIR/src/$(os_name)/package_setup.sh"
readonly DEVKIT_SETUP_SCRIPT="$DOT_DIR/src/$(os_name)/devkit_setup.sh"
readonly CONFIG_DEPLOY_SCRIPT="$DOT_DIR/src/$(os_name)/config_deploy.sh"

if [ ! -f "$PACKAGE_UPDATE_SCRIPT" ]; then
  error "not found: $PACKAGE_UPDATE_SCRIPT"
elif [ ! -f "$PACKAGE_SETUP_SCRIPT" ]; then
  error "not found: $PACKAGE_SETUP_SCRIPT"
elif [ ! -f "$DEVKIT_SETUP_SCRIPT" ]; then
  error "not found: $DEVKIT_SETUP_SCRIPT"
elif [ ! -f "$CONFIG_DEPLOY_SCRIPT" ]; then
  error "not found: $CONFIG_DEPLOY_SCRIPT"
fi

if [ "$(os_name)" != "darwin" ]; then
  ask_for_sudo_password
fi

while getopts usdc-: opt; do
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
      bash "$PACKAGE_UPDATE_SCRIPT"
      bash "$PACKAGE_SETUP_SCRIPT"
      bash "$DEVKIT_SETUP_SCRIPT"
      bash "$CONFIG_DEPLOY_SCRIPT"
      ;;
    -u | --package-update)
      bash "$PACKAGE_UPDATE_SCRIPT"
      ;;
    -s | --package-setup)
      bash "$PACKAGE_SETUP_SCRIPT"
      ;;
    -d | --devkit-setup)
      bash "$DEVKIT_SETUP_SCRIPT"
      ;;
    -c | --config-deploy)
      bash "$CONFIG_DEPLOY_SCRIPT"
      ;;
    -*)
      error "invalid option $1."
      ;;
  esac
done
