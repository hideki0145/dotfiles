# Enable selecting a specific version with 'mise use'.
# For reference, see: https://qiita.com/suin/items/909ec1172a80091946fe
mise_select() {
  local tool="${1:-}"
  local version
  [[ -n "$tool" ]] || return 1
  version=$(mise ls-remote "$tool" | sort -rV | fzf --tiebreak=index) || return
  mise use "$tool@$version"
}

# Check WSL.
check_wsl1_or_wsl2() {
  if [ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    return 1
  fi
  return 0
}
