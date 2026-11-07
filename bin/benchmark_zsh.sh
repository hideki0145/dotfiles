#!/bin/bash
# Measure interactive Zsh startup time and record comparison results.

set -euo pipefail

DOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly DOT_DIR
RUNS=30
WARMUP=3
LOGIN=false
DO_LOG=true
OUTPUT="$DOT_DIR/tmp/benchmark_zsh.jsonl"

error() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: benchmark_zsh.sh [COUNT] [OPTIONS]

Uses hyperfine when available, otherwise Bash time.

  -n, --runs N      Number of measured runs (default: 30).
  -w, --warmup N    Number of warm-up runs (default: 3).
  -l, --login       Measure only an interactive login shell (zsh -l -i -c exit).
  -o, --output FILE Append JSONL results to FILE (default: tmp/benchmark_zsh.jsonl).
      --no-log      Do not save results.
  -h, --help        Show this help.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
  -n | --runs | -w | --warmup | -o | --output)
    [ "$#" -ge 2 ] && [[ -n "$2" && "$2" != -* ]] || error "$1 requires a value."
    case "$1" in
    -n | --runs) RUNS="$2" ;;
    -w | --warmup) WARMUP="$2" ;;
    -o | --output) OUTPUT="$2" ;;
    esac
    shift 2
    ;;
  -l | --login)
    LOGIN=true
    shift
    ;;
  --no-log)
    DO_LOG=false
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  [0-9]*)
    RUNS="$1"
    shift
    ;;
  *) error "Unknown argument: $1 (use --help)." ;;
  esac
done

[[ "$RUNS" =~ ^[1-9][0-9]*$ ]] || error "--runs must be a positive integer."
[[ "$WARMUP" =~ ^(0|[1-9][0-9]*)$ ]] || error "--warmup must be a non-negative integer."

for tool in zsh jq; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf "Error: %s required.\n" "$tool" >&2
    exit 1
  fi
done

ZARGS=(-i -c exit)
if $LOGIN; then
  ZARGS=(-l -i -c exit)
fi
COMMAND="zsh ${ZARGS[*]}"
ZSH_VERSION="$(zsh --version)"
ENGINE=bash-time
HYPERFINE_VERSION=""
if command -v hyperfine >/dev/null 2>&1; then
  ENGINE=hyperfine
  HYPERFINE_VERSION="$(hyperfine --version)"
fi
OS_NAME="$(uname -srm)"
COMMIT=unknown
if command -v git >/dev/null 2>&1 && git -C "$DOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  COMMIT="$(git -C "$DOT_DIR" rev-parse --short HEAD)"
  if [ -n "$(git -C "$DOT_DIR" status --porcelain)" ]; then
    COMMIT="${COMMIT}+dirty"
  fi
fi

printf 'Commit: %s\nZsh: %s\nEngine: %s\nOS: %s\n' "$COMMIT" "$ZSH_VERSION" "${HYPERFINE_VERSION:-$ENGINE}" "$OS_NAME"
printf 'Runs: %s | Warm-up: %s | Login: %s\n' "$RUNS" "$WARMUP" "$LOGIN"

RESULT_FILE="$(mktemp /tmp/dotfiles-zsh-benchmark.XXXXXXXX)"
trap 'rm -f "$RESULT_FILE"' EXIT
if [ "$ENGINE" = hyperfine ]; then
  hyperfine --shell=none --warmup "$WARMUP" --runs "$RUNS" --export-json "$RESULT_FILE" "$COMMAND"
else
  for ((i = 0; i < WARMUP; i++)); do
    zsh "${ZARGS[@]}" >/dev/null
  done
  TIMEFORMAT=%R
  SAMPLES=$(
    {
      for ((i = 0; i < RUNS; i++)); do
        # Keep startup errors visible while capturing Bash's timing output.
        elapsed=$({ time zsh "${ZARGS[@]}" >/dev/null 2>&3; } 2>&1) || exit "$?"
        printf '%s\n' "${elapsed/,/.}"
      done
    } 3>&2
  )
  printf '%s\n' "$SAMPLES" | jq -Rn --arg command "$COMMAND" '
    [inputs | tonumber] as $times
    | ($times | sort) as $sorted
    | ($times | length) as $count
    | {results: [{command: $command, times: $times,
        mean: (($times | add) / $count),
        median: (($sorted[(($count - 1) / 2 | floor)] + $sorted[($count / 2 | floor)]) / 2),
        min: $sorted[0], max: $sorted[-1]}]}
  ' >"$RESULT_FILE"
  STATS="$(jq -r '.results[0] | [.mean, .median, .min, .max] | map(. * 1000) | @tsv' "$RESULT_FILE")"
  IFS=$'\t' read -r MEAN MEDIAN MIN MAX <<<"$STATS"
  LC_ALL=C printf 'Mean: %.2f ms\nMedian: %.2f ms\nMin: %.2f ms\nMax: %.2f ms\n' "$MEAN" "$MEDIAN" "$MIN" "$MAX"
fi

if $DO_LOG; then
  mkdir -p "$(dirname "$OUTPUT")"
  jq -c --arg timestamp "$(date +%Y-%m-%dT%H:%M:%S%z)" \
    --arg cwd "$PWD" \
    --arg commit "$COMMIT" --arg zsh "$ZSH_VERSION" --arg engine "$ENGINE" --arg hyperfine "$HYPERFINE_VERSION" --arg os "$OS_NAME" \
    --argjson runs "$RUNS" --argjson warmup "$WARMUP" --argjson login "$LOGIN" \
    '{timestamp: $timestamp, cwd: $cwd, commit: $commit, zsh: $zsh, engine: $engine, hyperfine: $hyperfine, os: $os,
      runs: $runs, warmup: $warmup, login: $login, benchmark: .}' "$RESULT_FILE" >>"$OUTPUT"
  printf 'Log: %s\n' "$OUTPUT"
fi
