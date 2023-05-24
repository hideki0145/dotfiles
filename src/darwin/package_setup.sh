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

# CUI packages
# git
package_name "git"
if ! has_formula "git"; then
  brew install git
else
  git --version
fi
if [ -z "`git config --list | grep user.name`" ]; then
  git config --global user.name "Hideki Miyamoto"
fi
if [ -z "`git config --list | grep user.useConfigOnly`" ]; then
  git config --global user.useConfigOnly true
fi
if [ -z "`git config --list | grep color.ui`" ]; then
  git config --global color.ui auto
fi
if [ -z "`git config --list | grep pull.rebase`" ]; then
  git config --global pull.rebase false
fi
git --no-pager config --global --list
if [ ! -d "$HOME/.config/git" ]; then
  mkdir -p "$HOME/.config/git"
fi
ln -snfv "$DOT_DIR/config/git/ignore" "$HOME/.config/git/ignore"

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
  description "Change login shell."
  chsh -s $(which zsh)
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

# sqlite3
package_name "sqlite3"
if ! has_formula "sqlite"; then
  brew install sqlite
else
  sqlite3 --version
fi

# tig
package_name "tig"
if ! has_formula "tig"; then
  brew install tig
else
  tig --version
fi

# lazygit
package_name "lazygit"
if ! has_formula "lazygit"; then
  brew install jesseduffield/lazygit/lazygit
else
  lazygit --version
fi

# lazydocker
package_name "lazydocker"
if ! has_formula "lazydocker"; then
  brew install jesseduffield/lazydocker/lazydocker
else
  lazydocker --version
fi

# asdf
package_name "asdf"
if ! has "asdf"; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  cd ~/.asdf
  git checkout "$(git describe --abbrev=0 --tags)"
  cd -
  echo '' >> ~/.bashrc
  echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
  echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash
else
  asdf --version
fi
asdf update
asdf plugin update --all

if [ -z "`asdf plugin list | grep nodejs`" ]; then
  brew install gpg gawk
  asdf plugin add nodejs
else
  asdf plugin list --urls --refs | grep nodejs
fi
if [ -z "`asdf plugin list | grep python`" ]; then
  brew install openssl readline sqlite3 xz zlib tcl-tk
  asdf plugin add python
else
  asdf plugin list --urls --refs | grep python
fi
if [ -z "`asdf plugin list | grep ruby`" ]; then
  brew install openssl@1.1 readline libyaml
  asdf plugin add ruby
else
  asdf plugin list --urls --refs | grep ruby
fi

# yarn
package_name "yarn"
if ! has "yarn"; then
  if has "npm"; then
    npm install -g yarn
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
  cask_version "google-chrome"
fi

# karabiner elements
package_name "karabiner elements"
if ! has_cask "karabiner-elements"; then
  brew install --cask karabiner-elements
else
  cask_version "karabiner-elements"
fi

# onedrive
package_name "onedrive"
if ! has_cask "onedrive"; then
  brew install --cask onedrive
else
  cask_version "onedrive"
fi

# visual studio code
package_name "visual studio code"
if ! has_cask "visual-studio-code"; then
  brew install --cask visual-studio-code
else
  cask_version "visual-studio-code"
fi

# deepl
package_name "deepl"
if ! has_cask "deepl"; then
  brew install --cask deepl
else
  cask_version "deepl"
fi

# hackgen
package_name "hackgen"
if ! has_cask "font-hackgen"; then
  brew tap homebrew/cask-fonts
  brew install --cask font-hackgen font-hackgen-nerd
else
  cask_version "font-hackgen"
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
