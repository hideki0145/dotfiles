#!/bin/bash
# Run Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
readonly GITHUB_REPOSITORY="hideki0145/dotfiles"
readonly DOTFILES_ORIGIN_URL="https://github.com/$GITHUB_REPOSITORY.git"
readonly DEFAULT_DOTFILES_BRANCH="main"
readonly INSTALL_SCRIPT="$DOT_DIR/src/install.sh"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
readonly ORIGINAL_ARGS=("$@")

DOTFILES_BRANCH="$DEFAULT_DOTFILES_BRANCH"
while [ "$#" -gt 0 ]; do
  case "$1" in
  --branch)
    if [ "$#" -lt 2 ] || [[ "$2" = -* ]]; then
      printf "Error: --branch requires a value.\n" 1>&2
      exit 1
    fi
    DOTFILES_BRANCH="$2"
    shift
    ;;
  --help | -h)
    cat <<EOF
Usage: $DOT_DIR/src/run.sh [OPTIONS]

Options:
  --all                 Run all setup steps. This is the default.
  --branch BRANCH       Use a specific dotfiles branch. Defaults to main.
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
    # Other options are validated by install.sh after bootstrap completes.
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
        printf "Error: Failed to download utils script.\n" 1>&2
        exit 1
      }
  elif type "wget" >/dev/null 2>&1; then
    wget -O "$UTILS_SCRIPT" "$DOTFILES_UTILS_URL" ||
      {
        printf "Error: Failed to download utils script.\n" 1>&2
        exit 1
      }
  else
    printf "Error: curl or wget required.\n" 1>&2
    exit 1
  fi
fi
# shellcheck source=utils.sh
source "$UTILS_SCRIPT"

if [ ! -d "$DOT_DIR/.git" ]; then
  rm -rf "$DOT_DIR"
  if has "git"; then
    download "Clone dotfiles repository ($DOTFILES_BRANCH)..."
    git clone --branch "$DOTFILES_BRANCH" "$DOTFILES_ORIGIN_URL" "$DOT_DIR" ||
      error "Failed to clone dotfiles repository branch: $DOTFILES_BRANCH"
  elif has "curl" || has "wget"; then
    download "Download dotfiles repository ($DOTFILES_BRANCH)..."
    mkdir -p "$DOT_DIR/tmp"
    dotfiles_tarball="$DOT_DIR/tmp/dotfiles.tar.gz"
    if has "curl"; then
      curl -fSL "$DOTFILES_TARBALL_URL" -o "$dotfiles_tarball"
    elif has "wget"; then
      wget -O "$dotfiles_tarball" "$DOTFILES_TARBALL_URL"
    fi ||
      error "Failed to download dotfiles repository branch: $DOTFILES_BRANCH"
    tar zxf "$dotfiles_tarball" --strip-components=1 -C "$DOT_DIR" ||
      error "Failed to download dotfiles repository branch: $DOTFILES_BRANCH"
  else
    error "curl or wget required."
  fi
else
  download "Pull dotfiles repository ($DOTFILES_BRANCH)..."
  git -C "$DOT_DIR" fetch origin "$DOTFILES_BRANCH:refs/remotes/origin/$DOTFILES_BRANCH" ||
    error "Failed to fetch dotfiles repository branch: $DOTFILES_BRANCH"
  if git -C "$DOT_DIR" show-ref --verify --quiet "refs/heads/$DOTFILES_BRANCH"; then
    git -C "$DOT_DIR" switch "$DOTFILES_BRANCH" ||
      error "Failed to switch dotfiles repository branch: $DOTFILES_BRANCH"
  else
    git -C "$DOT_DIR" switch --track -c "$DOTFILES_BRANCH" "origin/$DOTFILES_BRANCH" ||
      error "Failed to switch dotfiles repository branch: $DOTFILES_BRANCH"
  fi
  git -C "$DOT_DIR" merge --ff-only "origin/$DOTFILES_BRANCH" ||
    error "Failed to merge dotfiles repository branch: $DOTFILES_BRANCH"
fi

if [ ! -f "$INSTALL_SCRIPT" ]; then
  error "Not found: $INSTALL_SCRIPT"
fi

exec /bin/bash "$INSTALL_SCRIPT" "${ORIGINAL_ARGS[@]}"
