. "$HOME/.dotfiles/config/zsh/common/pre.zsh"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# zsh
FPATH="$HOME/.zsh/completions:$FPATH"

# postgresql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

. "$HOME/.dotfiles/config/zsh/common/post.zsh"
