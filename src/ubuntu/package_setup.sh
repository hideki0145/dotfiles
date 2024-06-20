#!/bin/bash
# Package Setup Script for Ubuntu.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh
. "$DOT_DIR"/src/$(os_name)/utils.sh

title "Package Setup start..."


# CUI packages
# git
package_name "git"
if ! has "git"; then
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt update
  sudo apt install -y git
else
  git --version
  git --no-pager config --global --list
fi

# vim
package_name "vim"
if ! has "vim"; then
  sudo apt install -y vim
else
  vim --version | head -n 1
fi
if [ ! -d ~/.vim/autoload ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# zsh
package_name "zsh"
if ! has "zsh"; then
  sudo apt install -y zsh
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

# tig
package_name "tig"
if ! has "tig"; then
  sudo apt install -y tig
else
  tig --version
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
asdf plugin update --all > /dev/null

if [ -z "`asdf plugin list | grep nodejs`" ]; then
  asdf plugin add nodejs
else
  asdf plugin list --urls --refs | grep nodejs
fi
if [ -z "`asdf plugin list | grep python`" ]; then
  sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  asdf plugin add python
else
  asdf plugin list --urls --refs | grep python
fi
if [ -z "`asdf plugin list | grep ruby`" ]; then
  if [ "$(os_version)" = "18.04" ]; then
    sudo apt install -y autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev libdb-dev uuid-dev
  else
    sudo apt install -y autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
  fi
  asdf plugin add ruby
else
  asdf plugin list --urls --refs | grep ruby
fi
if [ -z "`asdf plugin list | grep rust`" ]; then
  asdf plugin add rust
else
  asdf plugin list --urls --refs | grep rust
fi

# yarn
package_name "yarn"
if ! has "yarn"; then
  if has "corepack"; then
    corepack enable
    asdf reshim nodejs
  else
    skip "yarn"
  fi
else
  yarn --version
fi

# GUI packages
# google chrome
package_name "google chrome"
if ! has "google-chrome"; then
  curl -LsS "https://dl.google.com/linux/direct/google-chrome-stable_current_$(dpkg --print-architecture).deb" -o "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  sudo apt install -y "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  rm "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
else
  google-chrome --version
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
