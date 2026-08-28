#!/bin/bash
# Package: homebrew-casks (darwin only)

case "$DOTFILES_OS_NAME" in
darwin) ;;
*) return 0 ;;
esac

readonly CASK_ENTRIES=(
  # cask|version_type|version_target|version_argument
  "karabiner-elements|plist|/Applications/Karabiner-Elements.app/Contents"
  "onedrive|plist|/Applications/OneDrive.app/Contents"
  "visual-studio-code|command|/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code|--version"
  "iterm2|plist|/Applications/iTerm.app/Contents"
  "slack|plist|/Applications/Slack.app/Contents"
  "asana|plist|/Applications/Asana.app/Contents"
  "zoom|plist|/Applications/zoom.us.app/Contents"
  "joplin|plist|/Applications/Joplin.app/Contents"
  "clibor|plist|/Applications/Clibor.app/Contents"
  "gimp|command|gimp|--version"
  "keyclu|plist|/Applications/KeyClu.app/Contents"
  "scroll-reverser|plist|/Applications/Scroll Reverser.app/Contents"
  "tailscale-app|plist|/Applications/Tailscale.app/Contents"
  "font-hackgen|cask"
  "font-hackgen-nerd|cask"
)

for entry in "${CASK_ENTRIES[@]}"; do
  IFS='|' read -r cask version_type version_target version_argument <<<"$entry"

  package_name "$cask"

  if ! has_cask "$cask"; then
    brew install -y --cask "$cask"
  fi

  case "$version_type" in
  cask)
    cask_version "$cask"
    ;;
  plist)
    plist_version "$version_target"
    ;;
  command)
    "$version_target" "$version_argument"
    ;;
  *) ;;
  esac
done
