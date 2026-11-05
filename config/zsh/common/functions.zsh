# Enable selecting a specific version with 'mise use'.
# For reference, see: https://qiita.com/suin/items/909ec1172a80091946fe
mise_select() {
  local tool="${1:-}"
  local version
  if [[ -z "$tool" ]]; then
    print -u2 'Usage: mise_select TOOL'
    return 1
  fi
  version=$(mise ls-remote "$tool" | sort -rV | fzf --tiebreak=index) || return
  mise use "$tool@$version"
}

# Copy UTF-8 text from standard input to the clipboard.
clipcopy() {
  setopt localoptions pipefail
  if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    { printf '\xff\xfe'; iconv -f UTF-8 -t UTF-16LE; } | /mnt/c/Windows/System32/clip.exe
  elif [[ "$OSTYPE" == darwin* ]]; then
    LC_CTYPE=UTF-8 pbcopy
  else
    print -u2 'clipcopy: only WSL and macOS are supported.'
    return 1
  fi
}

# Convert Markdown to PDF using the same basename.
md2pdf() {
  if (( $# == 0 )); then
    print -u2 'Usage: md2pdf INPUT [OPTIONS]'
    return 1
  fi
  local input="${1%/}"
  shift
  npx @pfnet-research/pfpdf@latest --input "$input" --output "${input:r}.pdf" "$@"
}
