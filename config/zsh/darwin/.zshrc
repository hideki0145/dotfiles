# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# zsh
FPATH="$HOME/.zsh/completions:$FPATH"

# Update FPATH before sourcing init.zsh.
. "$HOME/.dotfiles/config/zsh/common/init.zsh"

# postgresql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
