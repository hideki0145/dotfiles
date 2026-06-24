# Enable mise shims before Prezto initializes.
if [[ -d "$HOME/.local/share/mise/shims" ]]; then
  path=("$HOME/.local/share/mise/shims" ${path:#"$HOME/.local/share/mise/shims"})
fi
