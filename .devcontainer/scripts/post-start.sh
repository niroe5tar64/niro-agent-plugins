#!/usr/bin/env bash
set -euo pipefail

git config --global --add safe.directory "$PWD" || true
export PATH="$HOME/.local/bin:$PATH"

# 必要ならここに軽いチェックだけ置く
command -v claude >/dev/null 2>&1 || echo "claude not found in PATH"
command -v mise >/dev/null 2>&1 || echo "mise not found in PATH"
command -v mise >/dev/null 2>&1 && mise exec -- bun --version >/dev/null 2>&1 || echo "bun is not available via mise"
