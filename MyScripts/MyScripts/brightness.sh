#!/usr/bin/env bash

# set-brightness.sh
# Usage:
#   ./set-brightness.sh 50%    # set to 50%
#   ./set-brightness.sh +10%   # increase by 10%
#   ./set-brightness.sh 10%-   # decrease by 10%

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <brightness>"
  echo "Examples:"
  echo "  $0 50%"
  echo "  $0 +10%"
  echo "  $0 10%-"
  exit 1
fi

BRIGHTNESS="$1"

# Prefer brightnessctl
if command -v brightnessctl >/dev/null 2>&1; then
  brightnessctl set "$BRIGHTNESS"
  exit $?
fi

# Fallback to xbacklight
if command -v xbacklight >/dev/null 2>&1; then
  case "$BRIGHTNESS" in
  +*%)
    VALUE="${BRIGHTNESS#+}"
    VALUE="${VALUE%\%}"
    exec xbacklight -inc "$VALUE"
    ;;
  *%-)
    VALUE="${BRIGHTNESS%-}"
    VALUE="${VALUE%\%}"
    exec xbacklight -dec "$VALUE"
    ;;
  *%)
    VALUE="${BRIGHTNESS%\%}"
    exec xbacklight -set "$VALUE"
    ;;
  *)
    echo "Unsupported format for xbacklight fallback: $BRIGHTNESS"
    exit 1
    ;;
  esac
fi

echo "Error: neither brightnessctl nor xbacklight is installed."
exit 1
