#!/bin/bash
# Setup Script.

# main
readonly DOT_DIR="$HOME/.dotfiles"
. "$DOT_DIR"/etc/utils.sh

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
  cp "$DOT_DIR/config/zsh/.zsh_history" "$HOME/.zsh_history"
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
  if (! os_wsl || os_wsl2) && ! os_raspbian; then
    sudo apt install -y ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
    cat /etc/group | grep docker
    sudo mkdir -p /usr/local/lib/docker/cli-plugins/
    compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\Kv[\d.]+')
    sudo curl -SL "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
  else
    skip "docker"
  fi
else
  docker --version
  docker compose version
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
if ! os_raspbian; then
  compose_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[\d.]+')
  if ! has "lazygit" || [ ! "$compose_version" = "$(lazygit --version | grep -Po 'version=\K[\d.]+')" ]; then
    curl -SL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${compose_version}_$(uname -s)_$(uname -m).tar.gz" -o "$DOT_DIR/tmp/lazygit.tar.gz"
    sudo tar xf "$DOT_DIR/tmp/lazygit.tar.gz" -C /usr/bin lazygit
  fi
  lazygit --version
else
  skip "lazygit"
fi
echo "*******************"

# genie
echo "***** genie *****"
if ! has "genie"; then
  if os_wsl2; then
    sudo wget -O /etc/apt/trusted.gpg.d/wsl-transdebian.gpg https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg
    sudo chmod a+r /etc/apt/trusted.gpg.d/wsl-transdebian.gpg
    echo "deb https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/wsl-transdebian.list > /dev/null
    echo "deb-src https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/wsl-transdebian.list > /dev/null
    sudo apt update
    sudo apt install -y systemd-genie
    sudo sed -i -e "s/systemd-timeout=.*/systemd-timeout=30/g" /etc/genie.ini
    sudo systemctl set-default multi-user.target
    sudo ssh-keygen -A
    sudo e2label $(df / | awk '/\//{print $1}') cloudimg-rootfs
    sudo systemctl disable multipathd.service
    echo '#!/bin/sh' | sudo tee /etc/rc.local > /dev/null
    echo 'ls /proc/sys/fs/binfmt_misc > /dev/null 2>&1 || mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc' | sudo tee -a /etc/rc.local > /dev/null
    sudo chmod +x /etc/rc.local
  else
    skip "genie"
  fi
else
  genie --version
fi
echo "*******************"


# Setup complete
readonly FIRST_RUN="$DOT_DIR/tmp/first_run"
echo ""
if [ -e "$FIRST_RUN" ]; then
  echo "Setup complete!"
  echo "Please restarting your shell."
else
  touch "$FIRST_RUN"
  echo "First setup complete!"
  echo "You run it for the first time, please deployment of dotfiles, and restarting your shell."
  echo "After that, please re-run this script again."
fi
