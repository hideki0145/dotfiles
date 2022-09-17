#!/bin/bash
# Setup Script for Darwin.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/src/utils.sh


# homebrew
echo "***** homebrew *****"
if ! has "brew"; then
  xcode-select --install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew --version
fi
echo "********************"

# git
echo "***** git *****"
if ! has "git"; then
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
echo "***************"

# vim
echo "***** vim *****"
if ! has "vim"; then
  brew install vim
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
  brew install zsh
else
  zsh --version
fi
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*; do
    [ "${rcfile##*/}" = "README.md" ] && continue
    ln -snfv "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
  done
  cp "$DOT_DIR/config/zsh/darwin/.zsh_history.sample" "${ZDOTDIR:-$HOME}/.zsh_history"
  echo "Change login shell."
  chsh -s $(which zsh)
else
  cd "${ZDOTDIR:-$HOME}/.zprezto"
  git pull
  git submodule update --init --recursive
fi
echo "***************"

# asdf
echo "***** asdf *****"
if ! has "asdf"; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  cd ~/.asdf
  git checkout "$(git describe --abbrev=0 --tags)"
  cd -
  echo '' >> ~/.bashrc
  echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
  echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
else
  asdf --version
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
fi
echo "******************"

# tig
echo "***** tig *****"
if ! has "tig"; then
  brew install tig
else
  tig --version
fi
echo "***************"


# Setup complete
readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
echo ""
if [ -f "$FIRST_RUN" ]; then
  echo "Setup complete!"
  echo "Please restarting your shell."
else
  touch "$FIRST_RUN"
  echo "First setup complete!"
  echo "You run it for the first time, please deployment of dotfiles, and restarting your shell."
  echo "After that, please re-run this script again."
fi
