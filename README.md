# dotfiles

This repository is dotfiles available for **Ubuntu** or **macOS** setups.

## How to use

```sh
# Setup the packages by executing one of the one-liners.
bash -c "$(curl -LsS https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/install.sh)" -s --setup
bash -c "$(wget -qO - https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/install.sh)" -s --setup

# Deployment the dotfiles by executing one of the one-liners.
bash -c "$(curl -LsS https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/install.sh)" -s --deploy
bash -c "$(wget -qO - https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/install.sh)" -s --deploy
```

## Dependencies

### Ubuntu

```sh
# curl or wget must be installed.
sudo apt install curl
sudo apt install wget
```

### macOS

```sh
# Xcode Command Line Tools must be installed.
xcode-select --install
```
