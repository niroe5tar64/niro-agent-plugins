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

# Check if file is tracked by git
is_git_tracked() {
  local file="$1"
  local dir

  # Get directory of the file (or use file itself if it's a directory)
  if [ -d "$file" ]; then
    dir="$file"
  else
    dir="$(dirname "$file")"
  fi

  # Check if we're in a git repository and file is tracked
  (cd "$dir" 2>/dev/null && git ls-files --error-unmatch "$file" >/dev/null 2>&1)
}

# Extract file paths from rm command
extract_rm_targets() {
  local cmd="$1"
  local targets=""
  local in_option=false

  # Skip if not an rm command
  [[ ! "$cmd" =~ ^rm[[:space:]] ]] && return 1

  # Parse arguments (skip options and flags)
  for arg in $cmd; do
    # Skip the 'rm' command itself
    [ "$arg" = "rm" ] && continue

    # Skip options (starting with -)
    [[ "$arg" =~ ^- ]] && continue

    # This is a file/directory target
    if [ -n "$targets" ]; then
      targets="$targets"$'\n'"$arg"
    else
      targets="$arg"
    fi
  done

  [ -n "$targets" ] && echo "$targets" && return 0
  return 1
}

# Check if all rm targets are git-tracked
all_rm_targets_git_tracked() {
  local cmd="$1"
  local targets

  targets="$(extract_rm_targets "$cmd")" || return 1
  [ -z "$targets" ] && return 1

  while IFS= read -r target; do
    target="$(trim "${target:-}")"
    [ -z "$target" ] && continue

    # Expand glob patterns if they exist
    if [[ "$target" == *"*"* ]] || [[ "$target" == *"?"* ]]; then
      # For glob patterns, check each expanded file
      local expanded_any=false
      for expanded in $target; do
        [ ! -e "$expanded" ] && continue
        expanded_any=true
        if ! is_git_tracked "$expanded"; then
          return 1
        fi
      done
      # If nothing was expanded, consider it not git-tracked
      [ "$expanded_any" = false ] && return 1
    else
      # For regular paths, check directly
      if ! is_git_tracked "$target"; then
        return 1
      fi
    fi
  done <<<"$targets"

  return 0
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

# Determine project root (from CLAUDE_PROJECT_DIR or fallback to PWD)
project_root="${CLAUDE_PROJECT_DIR:-$PWD}"

# Separate patterns into two categories:
# 1. default_patterns: Plugin defaults (skipped for git-tracked files)
# 2. settings_patterns: User/project settings (always enforced)
default_patterns=""
settings_patterns=""

# 1. Plugin default patterns (skipped for git-tracked file deletions)
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  default_config="${CLAUDE_PLUGIN_ROOT}/config/default-deny-patterns.json"
  if [ -f "$default_config" ]; then
    default_patterns="$(extract_patterns_from_file "$default_config")"
  fi
fi

# 2. User home settings (always enforced)
user_settings="$HOME/.claude/settings.json"
if [ -f "$user_settings" ]; then
  user_patterns="$(extract_patterns_from_file "$user_settings")"
  if [ -n "$user_patterns" ]; then
    settings_patterns="$user_patterns"
  fi
fi

# 3. Project settings (always enforced)
project_settings="${project_root}/.claude/settings.json"
if [ -f "$project_settings" ]; then
  project_patterns="$(extract_patterns_from_file "$project_settings")"
  if [ -n "$project_patterns" ]; then
    if [ -n "$settings_patterns" ]; then
      settings_patterns="$settings_patterns"$'\n'"$project_patterns"
    else
      settings_patterns="$project_patterns"
    fi
  fi
fi

# 4. Project local settings (always enforced, highest priority)
project_local_settings="${project_root}/.claude/settings.local.json"
if [ -f "$project_local_settings" ]; then
  project_local_patterns="$(extract_patterns_from_file "$project_local_settings")"
  if [ -n "$project_local_patterns" ]; then
    if [ -n "$settings_patterns" ]; then
      settings_patterns="$settings_patterns"$'\n'"$project_local_patterns"
    else
      settings_patterns="$project_local_patterns"
    fi
  fi
fi

# Remove duplicate patterns
default_patterns="$(echo "$default_patterns" | sort -u)"
settings_patterns="$(echo "$settings_patterns" | sort -u)"

# Check if command involves git-tracked files (for rm commands)
skip_default_patterns=false
if all_rm_targets_git_tracked "$command"; then
  skip_default_patterns=true
fi

# Build final deny_patterns list based on context
if [ "$skip_default_patterns" = true ]; then
  # Git-tracked file deletion: only apply settings patterns
  deny_patterns="$settings_patterns"
else
  # Normal case: apply both default and settings patterns
  if [ -n "$default_patterns" ] && [ -n "$settings_patterns" ]; then
    deny_patterns="$default_patterns"$'\n'"$settings_patterns"
  elif [ -n "$default_patterns" ]; then
    deny_patterns="$default_patterns"
  else
    deny_patterns="$settings_patterns"
  fi
  deny_patterns="$(echo "$deny_patterns" | sort -u)"
fi

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
