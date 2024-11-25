# Powerlevel10k prompt segments for mise.
# For reference, see: https://github.com/romkatv/powerlevel10k/issues/2212

() {
  function prompt_mise() {
    local plugins=("${(@f)$(mise ls --current 2>/dev/null | awk '!/\(symlink\)/ && $3!="~/mise.toml" && $3!="~/.config/mise/config.toml" {print $1, $2}')}")
    local plugin
    for plugin in ${(k)plugins}; do
      local parts=("${(@s/ /)plugin}")
      local tool=${(U)parts[1]}
      local version=${parts[2]}
      p10k segment -r -i "${tool}_ICON" -s $tool -t "$version"
    done
  }

  # Colors
  for var in ${(k)parameters[(I)POWERLEVEL9K_ASDF_*_FOREGROUND]}; do
    typeset -g ${${var//_ASDF_/_MISE_}//_NODEJS_/_NODE_}=${(P)var}
  done
  # Substitute the default asdf prompt element
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=("${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/asdf/mise}")
}
