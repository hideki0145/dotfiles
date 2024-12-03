# dotfiles

This repository is dotfiles available for **Ubuntu** or **macOS** setups.

## How to use

```sh
# All process by executing one of the one-liners.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash
# or...
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --all
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --all

# Package update by executing one of the one-liners.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --package-update
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --package-update

# Package setup by executing one of the one-liners.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --package-setup
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --package-setup

# Development kit package setup by executing one of the one-liners.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --devkit-setup
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --devkit-setup

# Config deployment by executing one of the one-liners.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --config-deploy
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --config-deploy
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
