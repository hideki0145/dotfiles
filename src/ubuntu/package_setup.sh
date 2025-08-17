#!/bin/bash
# Package Setup Script for Ubuntu.

# main
. "$DOT_DIR/src/utils.sh"
. "$DOT_DIR/src/$(os_name)/utils.sh"

title "Package Setup start..."

# Required packages
# curl
if ! has "curl"; then
  sudo apt install -y curl
fi

# pipx
package_name "pipx"
if ! has "pipx"; then
  sudo apt install -y pipx
  pipx ensurepath
else
  pipx --version
fi

# CUI packages
# git
package_name "git"
if ! has "git"; then
  sudo add-apt-repository -y ppa:git-core/ppa
  sudo apt update
  sudo apt install -y git
else
  git --version
  if [ -f "$HOME/.gitconfig" ]; then
    git --no-pager config --global --list
  fi
fi
if ! git config --list | grep -q include.path; then
  git config --global include.path ~/.gitconfig.local
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
  sudo sed -i.bak -e "/auth.*required.*pam_shells.so/s/required/sufficient/g" /etc/pam.d/chsh
  chsh -s "$(which zsh)"
  sudo sed -i.bak -e "/auth.*sufficient.*pam_shells.so/s/sufficient/required/g" /etc/pam.d/chsh
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
  cd "${ZDOTDIR:-$HOME}/.zprezto" || exit
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

# rustup
package_name "rustup"
if ! has "rustup"; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  echo '' >>~/.bashrc
  # shellcheck disable=SC2016
  echo '. "$HOME/.cargo/env"' >>~/.bashrc
else
  rustup update
  rustup --version
  rustc --version
fi

# mise
package_name "mise"
if ! has "mise"; then
  curl https://mise.run | sh
  echo '' >>~/.bashrc
  # shellcheck disable=SC2016
  echo 'eval "$(~/.local/bin/mise activate bash)"' >>~/.bashrc
  eval "$(~/.local/bin/mise activate bash)"
else
  mise --version
fi
mise completion zsh | sudo tee /usr/local/share/zsh/site-functions/_mise >/dev/null

mise self-update -y
mise upgrade
mise plugins upgrade

if ! mise list usage | grep -q usage; then
  mise use --global usage@latest
else
  mise list usage | grep usage
fi
if ! mise list fzf | grep -q fzf; then
  mise use --global fzf@latest
else
  mise list fzf | grep fzf
fi
if ! mise list shellcheck | grep -q shellcheck; then
  mise use --global shellcheck@latest
else
  mise list shellcheck | grep shellcheck
fi
if ! mise list shfmt | grep -q shfmt; then
  mise use --global shfmt@latest
else
  mise list shfmt | grep shfmt
fi
if ! mise list node | grep -q node; then
  mise use node@latest
else
  mise list node | grep node
fi
# For reference, see: https://github.com/pyenv/pyenv/wiki#suggested-build-environment
if ! mise list python | grep -q python; then
  sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  mise use python@latest
else
  mise list python | grep python
fi
# For reference, see: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
if ! mise list ruby | grep -q ruby; then
  if [ "$(os_version)" = "18.04" ]; then
    sudo apt install -y autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev libdb-dev uuid-dev
  else
    sudo apt install -y autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
  fi
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
if ! has "google-chrome"; then
  curl -LsS "https://dl.google.com/linux/direct/google-chrome-stable_current_$(dpkg --print-architecture).deb" -o "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  sudo apt install -y "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
  rm "$DOT_DIR/tmp/google-chrome-stable_current_$(dpkg --print-architecture).deb"
else
  google-chrome --version
fi

# Package Setup complete
if [ -f "$FIRST_RUN" ]; then
  result "Package Setup complete!"
  description "Please restarting your shell."
else
  touch "$FIRST_RUN"
  result "First Package Setup complete!"
  description "You run it for the first time, please deployment of config, and restarting your shell."
  description "After that, please re-run this script again."
fi
