#!/bin/bash
# Package: prezto

package_name "prezto"

PREZTO_DIR="${ZDOTDIR:-$HOME}/.zprezto"
if [ ! -d "$PREZTO_DIR" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$PREZTO_DIR"
  for rcfile in "$PREZTO_DIR"/runcoms/*; do
    [ "${rcfile##*/}" = "README.md" ] && continue
    ln -snfv "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
  done
else
  git -C "$PREZTO_DIR" fetch
  if [ -n "$(git -C "$PREZTO_DIR" rev-list -1 HEAD..'@{upstream}')" ]; then
    if git -C "$PREZTO_DIR" merge --ff-only '@{upstream}'; then
      git -C "$PREZTO_DIR" submodule sync --recursive
      git -C "$PREZTO_DIR" submodule update --init --recursive
    fi
  fi
  git -C "$PREZTO_DIR" log -1 --format='prezto %h (%cs)'
fi
PREZTO_CONTRIB_DIR="${ZDOTDIR:-$HOME}/.zprezto-contrib"
mkdir -p "$PREZTO_CONTRIB_DIR"
PREZTO_CONTRIB_MODULES=(
  "joshskidmore/zsh-fzf-history-search"
)
for repository in "${PREZTO_CONTRIB_MODULES[@]}"; do
  module_name="${repository##*/}"
  module_dir="$PREZTO_CONTRIB_DIR/$module_name"
  if [ -d "$module_dir" ]; then
    git -C "$module_dir" fetch
    if [ -n "$(git -C "$module_dir" rev-list -1 HEAD..'@{upstream}')" ]; then
      git -C "$module_dir" merge --ff-only '@{upstream}'
    fi
  else
    git clone "https://github.com/$repository.git" "$module_dir"
  fi
  git -C "$module_dir" log -1 --format="$module_name %h (%cs)"
done
