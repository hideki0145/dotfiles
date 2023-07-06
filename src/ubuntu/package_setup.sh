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

# sqlite3
package_name "sqlite3"
if ! has "sqlite3"; then
  sudo apt install -y sqlite3 libsqlite3-dev
else
  sqlite3 --version
fi

# tig
package_name "tig"
if ! has "tig"; then
  sudo apt install -y tig
else
  tig --version
fi

# lazygit
package_name "lazygit"
compose_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[\d.]+')
if ! has "lazygit" || [ ! "$compose_version" = "$(lazygit --version | grep -Po 'version=\K[\d.]+')" ]; then
  curl -LsS "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${compose_version}_$(uname -s)_$(uname -m).tar.gz" -o "$DOT_DIR/tmp/lazygit.tar.gz"
  sudo tar xf "$DOT_DIR/tmp/lazygit.tar.gz" -C /usr/bin lazygit
fi
lazygit --version

# lazydocker
package_name "lazydocker"
compose_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[\d.]+')
if ! has "lazydocker" || [ ! "$compose_version" = "$(lazydocker --version | grep -Po 'Version: \K[\d.]+')" ]; then
  curl -LsS "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${compose_version}_$(uname -s)_$(uname -m).tar.gz" -o "$DOT_DIR/tmp/lazydocker.tar.gz"
  sudo tar xf "$DOT_DIR/tmp/lazydocker.tar.gz" -C /usr/bin lazydocker
fi
lazydocker --version

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

# docker
package_name "docker"
if ! has "docker"; then
  if ! check_wsl1; then
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
