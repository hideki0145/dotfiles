#!/bin/bash
# Lint checks for shell scripts.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

for tool in shellcheck shfmt; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf "Error: %s required.\n" "$tool" 1>&2
    exit 1
  fi
done

shell_files=()
while IFS= read -r -d '' shell_file; do
  shell_files+=("$shell_file")
done < <(find bin src -type f -name '*.sh' -print0)

status=0
shellcheck "${shell_files[@]}" || status=1
shfmt -d "${shell_files[@]}" || status=1

if [ "$status" -ne 0 ]; then
  printf "✖ lint failed\n" 1>&2
  exit "$status"
fi

printf "✔ lint passed\n"
