#!/bin/bash
set -euo pipefail

# Install Claude Code statusLine configuration into settings.local.json.
# Idempotent: skips if already configured, warns if a different value is set.
# Self-contained: does not require CLAUDE_PLUGIN_ROOT or CLAUDE_PROJECT_DIR.

# ---- スクリプト自身の場所からパスを解決 ------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
STATUSLINE_COMMAND="${PLUGIN_ROOT}/scripts/statusline-command.sh"

# ---- プロジェクトルートの解決 -----------------------------------------------

PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SETTINGS_FILE="${PROJECT_DIR}/.claude/settings.local.json"

# ---- 既存設定チェック -------------------------------------------------------

mkdir -p "$(dirname "$SETTINGS_FILE")"

if [[ ! -f "$SETTINGS_FILE" ]]; then
    echo '{}' > "$SETTINGS_FILE"
fi

EXISTING_COMMAND=$(jq -r '.statusLine.command // empty' "$SETTINGS_FILE" 2>/dev/null || true)

if [[ "$EXISTING_COMMAND" == "$STATUSLINE_COMMAND" ]]; then
    echo "statusline: already configured (no changes made)" >&2
    exit 0
fi

if [[ -n "$EXISTING_COMMAND" ]]; then
    echo "statusline: statusLine.command is already set to a different value:" >&2
    echo "  current: $EXISTING_COMMAND" >&2
    echo "  wanted:  $STATUSLINE_COMMAND" >&2
    echo "statusline: skipping to avoid overwriting existing configuration." >&2
    echo "  To reinstall, remove statusLine from $SETTINGS_FILE first." >&2
    exit 1
fi

# ---- statusLine 設定書き込み -----------------------------------------------

jq \
    --arg statusline_cmd "$STATUSLINE_COMMAND" \
    '.statusLine = {
        "type": "command",
        "command": $statusline_cmd
    }' \
    "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"

mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

echo "statusline: configured '$SETTINGS_FILE'" >&2

exit 0
