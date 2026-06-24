# Source common pre-initialization.
source "$HOME/.dotfiles/config/zsh/common/preinit.zsh"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# zsh
fpath=("$HOME/.zsh/completions" ${fpath:#"$HOME/.zsh/completions"})

# Source common initialization.
# Update fpath before sourcing init.zsh.
source "$HOME/.dotfiles/config/zsh/common/init.zsh"

# postgresql
path=("/opt/homebrew/opt/libpq/bin" ${path:#"/opt/homebrew/opt/libpq/bin"})
