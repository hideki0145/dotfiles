# dotfiles

This repository is dotfiles available for **Ubuntu** or **macOS** setups.

## How to use

```sh
# All process by executing one of the one-liners.
bash -c "$(curl -LsS https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --all
bash -c "$(wget -qO - https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --all

# Package update by executing one of the one-liners.
bash -c "$(curl -LsS https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --package-update
bash -c "$(wget -qO - https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --package-update

# Package setup by executing one of the one-liners.
bash -c "$(curl -LsS https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --package-setup
bash -c "$(wget -qO - https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --package-setup

# Development kit package setup by executing one of the one-liners.
bash -c "$(curl -LsS https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --devkit-setup
bash -c "$(wget -qO - https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --devkit-setup

# Config deployment by executing one of the one-liners.
bash -c "$(curl -LsS https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --config-deploy
bash -c "$(wget -qO - https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh)" -s --config-deploy
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
# Rosetta 2 must be installed.
softwareupdate --install-rosetta --agree-to-license
```
