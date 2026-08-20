# Add user-installed Zsh completions before Prezto initializes.
fpath=("$HOME/.zsh/completions" ${fpath:#"$HOME/.zsh/completions"})

# Enable mise shims before Prezto initializes.
if [[ -d "$HOME/.local/share/mise/shims" ]]; then
  path=("$HOME/.local/share/mise/shims" ${path:#"$HOME/.local/share/mise/shims"})
fi
