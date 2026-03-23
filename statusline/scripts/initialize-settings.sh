#!/bin/bash
set -euo pipefail

# Initialize Claude Code statusLine configuration.
# Always writes to ${CLAUDE_PROJECT_DIR}/.claude/settings.local.json

# ---- 必須環境変数チェック --------------------------------------------------

if [[ -z "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
    echo "Error: CLAUDE_PLUGIN_ROOT is not set." >&2
    exit 1
fi

if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
    echo "Error: CLAUDE_PROJECT_DIR is not set." >&2
    exit 1
fi

STATUSLINE_COMMAND="${CLAUDE_PLUGIN_ROOT}/scripts/statusline-command.sh"

# ---- 設定ファイルパス -------------------------------------------------------

SETTINGS_FILE="${CLAUDE_PROJECT_DIR}/.claude/settings.local.json"

# ---- statusLine 設定書き込み -----------------------------------------------

mkdir -p "$(dirname "$SETTINGS_FILE")"

if [[ ! -f "$SETTINGS_FILE" ]]; then
    echo '{}' > "$SETTINGS_FILE"
fi

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
