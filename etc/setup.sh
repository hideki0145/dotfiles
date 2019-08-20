#!/bin/bash
# Setup Script.

# Check existence of the command.
has() {
  type "$1" > /dev/null 2>&1
  return $?
}

# main
readonly DOT_DIR="$HOME/.dotfiles"

sudo apt update


# git
echo "***** git *****"
if ! has "git"; then
  sudo apt install -y git
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
git config --global --list
if [ ! -d "$HOME/.config/git" ]; then
  mkdir -p "$HOME/.config/git"
fi
ln -snfv "$DOT_DIR/config/git/ignore" "$HOME/.config/git/ignore"
echo "***************"

# vim
echo "***** vim *****"
if ! has "vim"; then
  sudo apt install -y vim
else
  vim --version | head -n 1
fi
if [ ! -d ~/.vim/autoload ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
echo "***************"

# zsh
echo "***** zsh *****"
if ! has "zsh"; then
  sudo apt install -y zsh
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*
  do
    [ "${rcfile##*/}" = "README.md" ] && continue
    ln -snfv "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
  done
  echo "Change login shell."
  chsh -s $(which zsh)
else
  zsh --version
  cd "${ZDOTDIR:-$HOME}/.zprezto"
  git pull
  git submodule update --init --recursive
fi
echo "***************"

# anyenv
echo "***** anyenv *****"
if ! has "anyenv"; then
  git clone https://github.com/anyenv/anyenv ~/.anyenv
  echo '' >> ~/.bashrc
  echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(anyenv init -)"' >> ~/.bashrc
else
  anyenv --version
  if [ ! -d ~/.config/anyenv/anyenv-install ]; then
    anyenv install --init
    git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
    git clone https://github.com/znz/anyenv-git.git $(anyenv root)/plugins/anyenv-git
  fi
  anyenv update

  if ! has "nodenv"; then
    anyenv install nodenv
  else
    curl -fsSL https://github.com/nodenv/nodenv-installer/raw/master/bin/nodenv-doctor | bash
  fi
  if ! has "pyenv"; then
    anyenv install pyenv
    sudo apt install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  else
    pyenv --version
  fi
  if ! has "rbenv"; then
    anyenv install rbenv
    sudo apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev
  else
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
  fi
fi
echo "******************"

# yarn
echo "***** yarn *****"
if ! has "yarn"; then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update
  sudo apt install -y --no-install-recommends yarn
else
  yarn --version
fi
echo "****************"

# sqlite3
echo "***** sqlite3 *****"
sudo apt install -y libsqlite3-dev
echo "*******************"

# tig
echo "***** tig *****"
if ! has "tig"; then
  sudo apt install -y tig
else
  tig --version
fi
echo "***************"


# Setup complete
echo "Setup complete!"
echo "Please restarting your shell."
