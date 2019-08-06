#!/bin/bash
# Initialize Script.

# Check existence of the command.
has() {
  type "$1" >/dev/null 2>&1
  return $?
}

# main
sudo apt update


# git
echo "***** git *****"
if ! has "git"; then
  yes | sudo apt install git
else
  git --version
fi
if [ -z "`git config --list | grep user.name`" ]; then
  git config --global user.name "Hideki Miyamoto"
fi
if [ -z "`git config --list | grep color.ui`" ]; then
  git config --global color.ui auto
fi
git config --global --list
echo "***************"

# vim
echo "***** vim *****"
if ! has "vim"; then
  yes | sudo apt install vim
else
  vim --version
fi
if [ ! -d ~/.vim/autoload ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
echo "***************"

# nvm
echo "***** nvm *****"
readonly NVM_GITHUB="https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh"
if [ ! -d ~/.nvm ]; then
  curl -o- "$NVM_GITHUB" | bash
else
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm --version
  if [ -n "$BASH_VERSION" ]; then
    curl -o- "$NVM_GITHUB" | bash
  elif [ -n "$ZSH_VERSION" ]; then
    curl -o- "$NVM_GITHUB" | zsh
  fi
fi
echo "***************"

# yarn
echo "***** yarn *****"
if ! has "yarn"; then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update
  yes | sudo apt install --no-install-recommends yarn
else
  yarn --version
fi
echo "****************"

# rbenv
echo "***** rbenv *****"
if ! has "rbenv"; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo '' >> ~/.bashrc
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
else
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
  cd ~/.rbenv
  git pull
  cd ~/.rbenv/plugins/ruby-build
  git pull
fi
echo "*****************"

# sqlite3
echo "***** sqlite3 *****"
yes | sudo apt install libsqlite3-dev
echo "*******************"


# Restarting shell
exec $SHELL
