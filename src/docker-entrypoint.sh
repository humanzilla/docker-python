#!/usr/bin/env bash
set -euo pipefail

echo "===> Running: $@"
exec "$@"
exit 0
