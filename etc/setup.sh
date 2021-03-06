#!/bin/bash
# Setup Script.

# Check OS.
os_wsl() {
  if [ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    return 1
  fi
  return 0
}
os_raspbian() {
  grep --quiet "^model name\s*:\s*ARMv" /proc/cpuinfo > /dev/null 2>&1
  return $?
}
os_ubuntu() {
  if [ ! "$(lsb_release -cs)" = "$1" ]; then
    return 1
  fi
  return 0
}

# Check existence of the command.
has() {
  type "$1" > /dev/null 2>&1
  return $?
}

# Display setup skip message.
skip() {
  echo "Skip $1 setup."
}

# main
readonly DOT_DIR="$HOME/.dotfiles"

sudo apt update


# git
echo "***** git *****"
if ! has "git"; then
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt update
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

# asdf
echo "***** asdf *****"
if ! has "asdf"; then
  if ! os_raspbian; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    cd ~/.asdf
    git checkout "$(git describe --abbrev=0 --tags)"
    cd -
    echo '' >> ~/.bashrc
    echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
    echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
  else
    skip "asdf"
  fi
else
  asdf --version
  asdf update
  asdf plugin update --all

  if [ -z "`asdf plugin list | grep nodejs`" ]; then
    sudo apt install -y dirmngr gpg curl gawk
    asdf plugin add nodejs
  else
    asdf plugin list --urls --refs | grep nodejs
  fi
  if [ -z "`asdf plugin list | grep python`" ]; then
    sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    asdf plugin add python
  else
    asdf plugin list --urls --refs | grep python
  fi
  if [ -z "`asdf plugin list | grep ruby`" ]; then
    if os_ubuntu "bionic"; then
      sudo apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev libdb-dev
    else
      sudo apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
    fi
    asdf plugin add ruby
  else
    asdf plugin list --urls --refs | grep ruby
  fi
fi
echo "******************"

# yarn
echo "***** yarn *****"
if ! has "yarn"; then
  if has "npm"; then
    npm install -g yarn
  else
    skip "yarn"
  fi
else
  yarn --version
fi
echo "****************"

# docker
echo "***** docker *****"
if ! has "docker"; then
  if ! os_wsl && ! os_raspbian; then
    sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo gpasswd -a ${USER} docker
    cat /etc/group | grep docker
    sudo chmod 666 /var/run/docker.sock
    compose_version="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | sed -e 's/[^0-9\.]//g')"
    sudo curl -L "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  else
    skip "docker"
  fi
else
  docker --version
  docker-compose --version
fi
echo "******************"

# sqlite3
echo "***** sqlite3 *****"
if ! has "sqlite3"; then
  sudo apt install -y sqlite3 libsqlite3-dev
else
  sqlite3 --version
fi
echo "*******************"

# tig
echo "***** tig *****"
if ! has "tig"; then
  sudo apt install -y tig
else
  tig --version
fi
echo "***************"

# lazygit
echo "***** lazygit *****"
if ! has "lazygit"; then
  if ! os_raspbian; then
    sudo add-apt-repository -y ppa:lazygit-team/release
    sudo apt update
    sudo apt install -y lazygit
  else
    skip "lazygit"
  fi
else
  lazygit --version
fi
echo "*******************"


# Setup complete
echo "Setup complete!"
echo "Please restarting your shell."
echo "If you run it for the first time, please re-run this script again."
