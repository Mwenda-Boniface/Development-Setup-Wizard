#!/usr/bin/env bash
# Forwarding launcher to dev-wizard binary
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/bin/dev-wizard" "$@"
