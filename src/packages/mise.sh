#!/bin/bash
# Package: mise

package_name "mise"

if ! has "mise"; then
  curl https://mise.run | sh
  echo '' >>~/.bashrc
  # shellcheck disable=SC2016
  echo 'eval "$(~/.local/bin/mise activate bash)"' >>~/.bashrc
  eval "$(~/.local/bin/mise activate bash)"
else
  mise self-update -y --no-plugins
fi

mise --version
mise completion zsh | tee ~/.zsh/completions/_mise >/dev/null

setup_mise_tool() {
  local tool_spec="$1"
  local tool_name="${tool_spec%%@*}"
  shift

  if ! mise list "$tool_name" | grep -q "$tool_name"; then
    if [ "$#" -gt 0 ]; then
      case "$DOTFILES_OS_NAME" in
      ubuntu)
        sudo apt install -y "$@"
        ;;
      darwin)
        brew install -y "$@"
        ;;
      *) ;;
      esac
    fi
    mise use --global "$tool_spec"
  else
    mise list --global "$tool_name" | grep "$tool_name"
  fi
}
readonly MISE_GLOBAL_TOOLS=(
  usage@latest
  fzf@latest
  shellcheck@latest
  shfmt@latest
)
for tool_spec in "${MISE_GLOBAL_TOOLS[@]}"; do
  setup_mise_tool "$tool_spec"
done
case "$DOTFILES_OS_NAME" in
ubuntu)
  # For reference, see: https://github.com/nodejs/node/blob/main/BUILDING.md#official-binary-platforms-and-toolchains
  setup_mise_tool "node@lts" libatomic1
  # For reference, see: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  setup_mise_tool "python@latest" make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libzstd-dev
  # For reference, see: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  setup_mise_tool "ruby@latest" build-essential autoconf libssl-dev libyaml-dev zlib1g-dev libffi-dev libgmp-dev rustc
  ;;
darwin)
  setup_mise_tool "node@lts"
  # For reference, see: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  setup_mise_tool "python@latest" openssl@3 readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig
  # For reference, see: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  setup_mise_tool "ruby@latest" openssl@3 readline libyaml gmp autoconf
  ;;
*) ;;
esac
