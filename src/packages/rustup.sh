#!/bin/bash
# Package: rustup

package_name "rustup"

if ! has "rustup"; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  echo '' >>~/.bashrc
  # shellcheck disable=SC2016
  echo '. "$HOME/.cargo/env"' >>~/.bashrc
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
else
  rustup self update
fi

rustup --version
rustc --version
