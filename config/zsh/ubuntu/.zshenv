# Let Prezto initialize completions instead of Ubuntu's global zshrc.
skip_global_compinit=1

# Source Prezto's environment initialization.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv"
fi
