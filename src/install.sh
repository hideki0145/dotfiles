#!/bin/bash
# Installation Script.

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
  rm -rf "$DOT_DIR"
  if has "git"; then
    git clone "$DOTFILES_ORIGIN_URL" "$DOT_DIR"
  elif has "curl" || has "wget"; then
    if has "curl"; then
      curl -L "$DOTFILES_TARBALL_URL"
    elif has "wget"; then
      wget -O - "$DOTFILES_TARBALL_URL"
    fi | tar zxv
    mv -f dotfiles-main "$DOT_DIR"
  else
    error "curl or wget required."
  fi
else
  cd "$DOT_DIR"
  git pull
fi

readonly SETUP_SCRIPT="$DOT_DIR/src/$(os_name)/setup.sh"
readonly DEPLOY_SCRIPT="$DOT_DIR/src/$(os_name)/deploy.sh"

if [ ! -f "$SETUP_SCRIPT" ]; then
  error "not found: $SETUP_SCRIPT"
elif [ ! -f "$DEPLOY_SCRIPT" ]; then
  error "not found: $DEPLOY_SCRIPT"
fi

while [ $# -gt 0 ]; do
  case $1 in
    -s | --setup)
      bash "$SETUP_SCRIPT"
      ;;
    -d | --deploy)
      bash "$DEPLOY_SCRIPT"
      ;;
    -*)
      error "invalid option $1."
      ;;
    *)
      echo "argument $1."
      ;;
  esac
  shift
done
