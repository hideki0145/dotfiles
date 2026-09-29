#!/bin/bash
# Package: delta

package_name "delta"

case "$DOTFILES_OS_NAME" in
ubuntu)
  require_github_latest_version "dandavison/delta" DELTA_VERSION || return 0
  if ! has "delta" || [ ! "$DELTA_VERSION" = "$(delta --version | sed -n 's/^delta \([^[:space:]]*\).*$/\1/p')" ]; then
    deb_file="$(mktemp --suffix=.deb /tmp/git-delta.XXXXXXXXXX)" || return 0
    download_file "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_$(dpkg --print-architecture).deb" "$deb_file" "delta ${DELTA_VERSION}" || {
      rm -f "$deb_file"
      return 0
    }
    chmod 644 "$deb_file" || {
      rm -f "$deb_file"
      return 0
    }
    apt_install "$deb_file"
    rm -f "$deb_file"
  fi
  ;;
darwin)
  if ! has_formula "git-delta"; then
    brew_install git-delta
  fi
  ;;
*) ;;
esac

delta --version
case "$DOTFILES_OS_NAME" in
ubuntu)
  delta --generate-completion zsh | tee ~/.zsh/completions/_delta >/dev/null
  ;;
darwin) ;;
*) ;;
esac
