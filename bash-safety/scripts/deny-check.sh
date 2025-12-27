#!/usr/bin/env bash
set -euo pipefail

# ---- utilities --------------------------------------------------------------

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

# Bash glob match. NOTE: do not quote $pattern (glob needs expansion).
matches_deny_pattern() {
  local cmd pattern
  cmd="$(trim "$1")"
  pattern="$(trim "$2")"
  [[ "$cmd" == $pattern ]]
}

die() {
  # Hook error message (stderr) + Claude Code should treat non-zero as deny
  echo "Error: $*" >&2
  exit 2
}

# ---- read stdin JSON --------------------------------------------------------

input="$(cat || true)"

# We only support jq. If jq is missing, fail closed.
if ! command -v jq >/dev/null 2>&1; then
  die "jq が見つかりません。deny-check を実行できないため拒否します。"
fi

tool_name="$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || true)"

# Only check Bash tool calls
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

command="$(echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"
command="$(trim "$command")"

# If we couldn't read the command, fail closed (avoid "allow all" on format changes).
if [ -z "$command" ]; then
  die "Bash command が空、または読み取れませんでした（入力JSONの形式変更の可能性）。"
fi

# ---- load deny patterns from multiple sources -------------------------------

# Helper function to extract Bash(...) patterns from a JSON file
extract_patterns_from_file() {
  local file="$1"
  [ ! -f "$file" ] && return 0

  jq -r '
    (.permissions.deny // [])
    | .[]
    | select(type=="string")
    | select(startswith("Bash("))
    | sub("^Bash\\("; "")
    | sub("\\)$"; "")
  ' "$file" 2>/dev/null || true
}

# Collect patterns from multiple sources (all will be merged)
all_patterns=""

# 1. Plugin default patterns (always loaded if plugin is installed)
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  default_config="${CLAUDE_PLUGIN_ROOT}/config/default-deny-patterns.json"
  if [ -f "$default_config" ]; then
    plugin_patterns="$(extract_patterns_from_file "$default_config")"
    [ -n "$plugin_patterns" ] && all_patterns="$plugin_patterns"
  fi
fi

# 2. User home settings
user_settings="$HOME/.claude/settings.json"
if [ -f "$user_settings" ]; then
  user_patterns="$(extract_patterns_from_file "$user_settings")"
  if [ -n "$user_patterns" ]; then
    if [ -n "$all_patterns" ]; then
      all_patterns="$all_patterns"$'\n'"$user_patterns"
    else
      all_patterns="$user_patterns"
    fi
  fi
fi

# 3. Project local settings
project_settings="$PWD/.claude/settings.json"
if [ -f "$project_settings" ]; then
  project_patterns="$(extract_patterns_from_file "$project_settings")"
  if [ -n "$project_patterns" ]; then
    if [ -n "$all_patterns" ]; then
      all_patterns="$all_patterns"$'\n'"$project_patterns"
    else
      all_patterns="$project_patterns"
    fi
  fi
fi

# 4. Custom settings path (highest priority override)
if [ -n "${CLAUDE_SETTINGS_PATH:-}" ] && [ -f "$CLAUDE_SETTINGS_PATH" ]; then
  custom_patterns="$(extract_patterns_from_file "$CLAUDE_SETTINGS_PATH")"
  if [ -n "$custom_patterns" ]; then
    if [ -n "$all_patterns" ]; then
      all_patterns="$all_patterns"$'\n'"$custom_patterns"
    else
      all_patterns="$custom_patterns"
    fi
  fi
fi

# Remove duplicate patterns (sort -u)
deny_patterns="$(echo "$all_patterns" | sort -u)"

if [ -z "${deny_patterns//[[:space:]]/}" ]; then
  # No patterns found in any source => allow (don't break developers by default)
  exit 0
fi

# ---- check whole command ----------------------------------------------------

while IFS= read -r pattern; do
  pattern="$(trim "${pattern:-}")"
  [ -z "$pattern" ] && continue

  if matches_deny_pattern "$command" "$pattern"; then
    die "コマンドが拒否されました: '$command' (パターン: '$pattern')"
  fi
done <<<"$deny_patterns"

# ---- check split parts (; && || only) --------------------------------------

temp_command="$command"
temp_command="${temp_command//;/$'\n'}"
temp_command="${temp_command//&&/$'\n'}"
temp_command="${temp_command//\|\|/$'\n'}"

IFS=$'\n'
for cmd_part in $temp_command; do
  cmd_part="$(trim "${cmd_part:-}")"
  [ -z "$cmd_part" ] && continue

  while IFS= read -r pattern; do
    pattern="$(trim "${pattern:-}")"
    [ -z "$pattern" ] && continue

    if matches_deny_pattern "$cmd_part" "$pattern"; then
      die "コマンドが拒否されました: '$cmd_part' (パターン: '$pattern')"
    fi
  done <<<"$deny_patterns"
done

# Allow
exit 0
