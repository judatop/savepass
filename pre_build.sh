#!/bin/bash
# Kept for backwards compatibility: it used to only copy .env.<flavor>, leaving
# env.g.dart with the previous flavor's secrets. Always go through build.sh.
set -euo pipefail

exec "$(dirname "$0")/build.sh" "$@"
