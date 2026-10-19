#!/bin/bash
# Package: rustup

package_name "rustup"

if ! has "rustup"; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
else
  rustup self update
fi

verify_command rustup --version &&
  verify_command rustc --version &&
  verify_command cargo --version
