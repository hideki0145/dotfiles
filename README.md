# dotfiles

This repository is dotfiles available for **Ubuntu** or **macOS (Apple Silicon)** setups.

Unsupported OSes are blocked before setup starts.
To run on unsupported OSes at your own risk, set `DOTFILES_ALLOW_UNSUPPORTED_OS=true`.

## How to use

```sh
# All process by executing one of the one-liners.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash
# or...
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --all
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --all

# Use a specific branch.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --branch specific-branch-name
wget -qO- https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --branch specific-branch-name

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

# Run on unsupported OSes at your own risk.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | DOTFILES_ALLOW_UNSUPPORTED_OS=true bash

# Persistently skip Homebrew casks, mas, and Mac App Store apps.
curl -fsSL https://raw.githubusercontent.com/hideki0145/dotfiles/main/src/run.sh | bash -s -- --skip-homebrew-cask --skip-mas
# Remove a skip flag to enable its installation again.
rm "${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/skip_homebrew_cask"
rm "${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/skip_mas"
```

### First setup

1. Install the prerequisites listed in [Dependencies](#dependencies).
2. Run one of the `--all` commands above.
3. Review the summary, sign out and back in, and rerun the command to complete setup.

When running individual steps, run `--package-setup` before `--devkit-setup` or `--config-deploy`.

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

## Maintenance

Run the lint checks before committing changes:

```sh
bin/lint.sh
```

This checks shell scripts under `bin/` and `src/` using ShellCheck and shfmt.
`shellcheck` and `shfmt` must be installed.
Files are not modified, and the command exits with a non-zero status if any check fails.

Measure Zsh startup time (30 runs by default; requires Zsh and jq). Hyperfine is used when available; otherwise, Bash time is used.

```sh
bin/benchmark_zsh.sh
bin/benchmark_zsh.sh --runs 30 --warmup 3 --login
```

Results and comparison metadata are appended to `tmp/benchmark_zsh.jsonl`. Use `--help` for options, including `--no-log`.
This measures `zsh -i -c exit` (or `zsh -l -i -c exit` with `--login`), which does not include displaying the first prompt or completing deferred work.

Each JSONL line contains the results of one invocation. Inspect the latest result:

```sh
tail -n 1 tmp/benchmark_zsh.jsonl | jq .
```

Display historical mean startup times in milliseconds:

```sh
jq -sr '
  (["timestamp", "commit", "engine", "mean_ms"],
   (.[] | [.timestamp, .commit, .engine,
     ((.benchmark.results[0] | .mean // .summary.time_wall_clock.mean) * 100000 | round / 100)]))
  | @tsv
' tmp/benchmark_zsh.jsonl | column -t -s $'\t'
```

Compare results using the same measurement engine, login mode, and environment.
