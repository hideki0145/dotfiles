# homebrew
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# postgresql
path=("/opt/homebrew/opt/libpq/bin" ${path:#"/opt/homebrew/opt/libpq/bin"})

# Source common pre-initialization.
source "$HOME/.dotfiles/config/zsh/common/preinit.zsh"

# Source common initialization.
# Update fpath before sourcing init.zsh.
source "$HOME/.dotfiles/config/zsh/common/init.zsh"
