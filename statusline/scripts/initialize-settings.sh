#!/bin/bash
set -euo pipefail

# Initialize Claude Code statusLine configuration
# This script updates $CLAUDE_PROJECT_DIR/.claude/settings.local.json to enable the statusline plugin

SETTINGS_FILE="${CLAUDE_PROJECT_DIR}/.claude/settings.local.json"
STATUSLINE_COMMAND="${CLAUDE_PLUGIN_ROOT}/scripts/statusline-command.sh"

# Create settings directory if it doesn't exist
mkdir -p "$(dirname "$SETTINGS_FILE")"

# Create empty settings file if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

# Update settings.json with statusLine configuration using jq
# If statusLine already exists, update it; otherwise add it
jq \
  --arg statusline_cmd "$STATUSLINE_COMMAND" \
  '.statusLine = {
    "type": "command",
    "command": $statusline_cmd
  }' \
  "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"

mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

exit 0
