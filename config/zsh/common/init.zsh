readonly DOT_DIR="$HOME/.dotfiles"
readonly UTILS_SCRIPT="$DOT_DIR/src/utils.sh"
. "$UTILS_SCRIPT"
. "$DOT_DIR/src/$(os_name)/utils.sh"

export EDITOR="vim"
export VISUAL="vim"

# rustup
. "$HOME/.cargo/env"

# mise
eval "$(~/.local/bin/mise activate zsh)"

# sheldon
eval "$(sheldon source)"

# starship
eval "$(starship init zsh)"
