#!/bin/bash
set -euo pipefail

# Remove the statusLine configuration from settings.local.json.
# Only removes if the current value matches this plugin's command.
# Self-contained: does not require CLAUDE_PLUGIN_ROOT or CLAUDE_PROJECT_DIR.

# ---- スクリプト自身の場所からパスを解決 ------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
STATUSLINE_COMMAND="${PLUGIN_ROOT}/scripts/statusline-command.sh"

# ---- プロジェクトルートの解決 -----------------------------------------------

PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SETTINGS_FILE="${PROJECT_DIR}/.claude/settings.local.json"

# ---- 設定ファイル存在チェック -----------------------------------------------

if [[ ! -f "$SETTINGS_FILE" ]]; then
    echo "statusline: $SETTINGS_FILE not found, nothing to uninstall." >&2
    exit 0
fi

EXISTING_COMMAND=$(jq -r '.statusLine.command // empty' "$SETTINGS_FILE" 2>/dev/null || true)

if [[ -z "$EXISTING_COMMAND" ]]; then
    echo "statusline: statusLine is not set, nothing to uninstall." >&2
    exit 0
fi

if [[ "$EXISTING_COMMAND" != "$STATUSLINE_COMMAND" ]]; then
    echo "statusline: statusLine.command does not match this plugin's command:" >&2
    echo "  current: $EXISTING_COMMAND" >&2
    echo "  mine:    $STATUSLINE_COMMAND" >&2
    echo "statusline: skipping to avoid removing someone else's configuration." >&2
    exit 1
fi

# ---- statusLine 設定削除 ---------------------------------------------------

jq 'del(.statusLine)' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

echo "statusline: removed statusLine from '$SETTINGS_FILE'" >&2

exit 0
