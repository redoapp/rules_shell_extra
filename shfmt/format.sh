#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$4"
"$1" "${@:5}" "$2" >"$3"
