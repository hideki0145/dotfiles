#!/bin/bash
# Package: mas-apps (darwin only)

case "$DOTFILES_OS_NAME" in
darwin) ;;
*) return 0 ;;
esac

if ! has "mas"; then
  return 0
fi

readonly MAS_APP_ENTRIES=(
  # app_name|app_id
  "AllMyBatteries|1621263412"
  "Amphetamine|937984704"
  "Magnet|441258766"
  "Windows App|1295203466"
)

for entry in "${MAS_APP_ENTRIES[@]}"; do
  IFS='|' read -r app_name app_id <<<"$entry"

  package_name "$app_name"

  if ! has_mas "$app_id"; then
    mas install "$app_id"
  fi

  mas_version "$app_id"
done
