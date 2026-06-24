# Update FPATH before sourcing init.zsh.
. "$HOME/.dotfiles/config/zsh/common/init.zsh"

# ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  readonly SSH_KEY_LIFE_TIME_SEC=3600
  readonly SSH_AGENT_FILE="$HOME/.ssh_agent"
  test -f "$SSH_AGENT_FILE" && . "$SSH_AGENT_FILE" >/dev/null 2>&1
  if ! pgrep -x ssh-agent >/dev/null; then
    ssh-agent -t "$SSH_KEY_LIFE_TIME_SEC" | tee "$SSH_AGENT_FILE" >/dev/null
    . "$SSH_AGENT_FILE" >/dev/null 2>&1
  fi
fi

# gh
if check_wsl1_or_wsl2; then
  export GH_BROWSER="/mnt/c/Program\ Files/PowerShell/7/pwsh.exe -NoProfile -c start"
fi
