# Add user-installed Zsh completions before Prezto initializes.
fpath=("$HOME/.zsh/completions" ${fpath:#"$HOME/.zsh/completions"})

# Make mise tools available to Prezto modules before mise activation.
# For example, zsh-fzf-history-search checks for fzf when loaded.
if [[ -d "$HOME/.local/share/mise/shims" ]]; then
  path=("$HOME/.local/share/mise/shims" ${path:#"$HOME/.local/share/mise/shims"})
fi
