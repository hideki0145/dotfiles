# Enable selecting a specific version with 'mise use'.
# For reference, see: https://qiita.com/suin/items/909ec1172a80091946fe
mise_select() {
  if [[ -n "$1" ]]; then
    mise use "$1@$(mise ls-remote "$1" | sort -rV | fzf)"
  else
    return 1
  fi
}

# Check WSL.
check_wsl1_or_wsl2() {
  if [ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    return 1
  fi
  return 0
}
