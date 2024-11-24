#!/bin/bash
# Package Setup Script for Darwin.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh
. "$DOT_DIR"/src/$(os_name)/utils.sh

title "Package Setup start..."


# homebrew
package_name "homebrew"
if ! has "brew"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  brew --version
fi

# mas
package_name "mas"
if ! has_formula "mas"; then
  brew install mas
else
  mas version
fi

# CUI packages
# git
package_name "git"
if ! has_formula "git"; then
  brew install git
else
  git --version
  git --no-pager config --global --list
fi

# vim
package_name "vim"
if ! has_formula "vim"; then
  brew install vim
else
  vim --version | head -n 1
fi
if [ ! -d ~/.vim/autoload ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# zsh
package_name "zsh"
if ! has_formula "zsh"; then
  brew install zsh
  mkdir -p ~/.zsh/completions
  description "Change login shell."
  sudo sh -c 'echo "/opt/homebrew/bin/zsh" >> /etc/shells'
  chsh -s /opt/homebrew/bin/zsh
else
  zsh --version
fi
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*; do
    [ "${rcfile##*/}" = "README.md" ] && continue
    ln -snfv "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
  done
  cp "$DOT_DIR/config/zsh/$(os_name)/.zsh_history.sample" "${ZDOTDIR:-$HOME}/.zsh_history"
else
  cd "${ZDOTDIR:-$HOME}/.zprezto"
  git pull
  git submodule update --init --recursive
fi

# tig
package_name "tig"
if ! has_formula "tig"; then
  brew install tig
else
  tig --version
fi

# rustup
package_name "rustup"
if ! has "rustup"; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  echo '' >> ~/.bashrc
  echo '. "$HOME/.cargo/env"' >> ~/.bashrc
else
  rustup update
  rustup --version
  rustc --version
fi

# mise
package_name "mise"
if ! has "mise"; then
  curl https://mise.run | sh
  echo '' >> ~/.bashrc
  echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
  eval "$(~/.local/bin/mise activate bash)"
else
  mise --version
fi
mise completion zsh | tee ~/.zsh/completions/_mise > /dev/null

mise self-update -y
mise upgrade
mise plugins upgrade

if [ -z "`mise list usage | grep usage`" ]; then
  mise use --global usage@latest
else
  mise list usage | grep usage
fi
if [ -z "`mise list fzf | grep fzf`" ]; then
  mise use --global fzf@latest
else
  mise list fzf | grep fzf
fi
if [ -z "`mise list node | grep node`" ]; then
  mise use node@latest
else
  mise list node | grep node
fi
if [ -z "`mise list python | grep python`" ]; then
  brew install openssl readline sqlite3 xz zlib tcl-tk
  mise use python@latest
else
  mise list python | grep python
fi
if [ -z "`mise list ruby | grep ruby`" ]; then
  brew install openssl@3 readline libyaml gmp
  mise use ruby@latest
else
  mise list ruby | grep ruby
fi

# yarn
package_name "yarn"
if ! has "yarn"; then
  if has "corepack"; then
    corepack enable
  else
    skip "yarn"
  fi
else
  yarn --version
fi

# GUI packages
# google chrome
package_name "google chrome"
if ! has_cask "google-chrome"; then
  brew install --cask google-chrome
else
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version
fi

# karabiner elements
package_name "karabiner elements"
if ! has_cask "karabiner-elements"; then
  brew install --cask karabiner-elements
else
  plist_version "/Applications/Karabiner-Elements.app/Contents"
fi

# onedrive
package_name "onedrive"
if ! has_cask "onedrive"; then
  brew install --cask onedrive
else
  plist_version "/Applications/OneDrive.app/Contents"
fi

# visual studio code
package_name "visual studio code"
if ! has_cask "visual-studio-code"; then
  brew install --cask visual-studio-code
else
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" --version
fi

# iterm2
package_name "iterm2"
if ! has_cask "iterm2"; then
  brew install --cask iterm2
else
  plist_version "/Applications/iTerm.app/Contents"
fi

# slack
package_name "slack"
if ! has_cask "slack"; then
  brew install --cask slack
else
  plist_version "/Applications/Slack.app/Contents"
fi

# asana
package_name "asana"
if ! has_cask "asana"; then
  brew install --cask asana
else
  plist_version "/Applications/Asana.app/Contents"
fi

# zoom
package_name "zoom"
if ! has_cask "zoom"; then
  brew install --cask zoom
else
  plist_version "/Applications/zoom.us.app/Contents"
fi

# joplin
package_name "joplin"
if ! has_cask "joplin"; then
  brew install --cask joplin
else
  plist_version "/Applications/Joplin.app/Contents"
fi

# clibor
package_name "clibor"
if ! has_cask "clibor"; then
  brew install --cask clibor
else
  plist_version "/Applications/Clibor.app/Contents"
fi

# deepl
package_name "deepl"
if ! has_cask "deepl"; then
  brew install --cask deepl
else
  plist_version "/Applications/DeepL.app/Contents"
fi

# gimp
package_name "gimp"
if ! has_cask "gimp"; then
  brew install --cask gimp
else
  gimp --version
fi

# keyclu
package_name "keyclu"
if ! has_cask "keyclu"; then
  brew install --cask keyclu
else
  plist_version "/Applications/KeyClu.app/Contents"
fi

# hackgen
package_name "hackgen"
if ! has_cask "font-hackgen"; then
  brew tap homebrew/cask-fonts
  brew install --cask font-hackgen font-hackgen-nerd
else
  cask_version "font-hackgen"
fi

# AllMyBatteries
package_name "AllMyBatteries"
if ! has_mas 1621263412; then
  mas install 1621263412
else
  mas_version 1621263412
fi

# Amphetamine
package_name "Amphetamine"
if ! has_mas 937984704; then
  mas install 937984704
else
  mas_version 937984704
fi

# Magnet
package_name "Magnet"
if ! has_mas 441258766; then
  mas install 441258766
else
  mas_version 441258766
fi

# WireGuard
package_name "WireGuard"
if ! has_mas 1451685025; then
  mas install 1451685025
else
  mas_version 1451685025
fi


# Package Setup complete
readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
if [ -f "$FIRST_RUN" ]; then
  result "Package Setup complete!"
  description "Please restarting your shell."
else
  touch "$FIRST_RUN"
  result "First Package Setup complete!"
  description "You run it for the first time, please deployment of config, and restarting your shell."
  description "After that, please re-run this script again."
fi
