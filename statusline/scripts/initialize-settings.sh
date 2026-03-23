#!/bin/bash
set -euo pipefail

# Initialize Claude Code statusLine configuration.
# Scope is auto-detected from CLAUDE_PLUGIN_ROOT location + existing settings.
# Override with: --target user | project-local | project-shared

# ---- 引数パース ------------------------------------------------------------

TARGET=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target)
            shift
            case "${1:-}" in
                user|project-local|project-shared)
                    TARGET="$1"
                    ;;
                *)
                    echo "Error: --target must be one of: user, project-local, project-shared" >&2
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Error: Unknown argument: $1" >&2
            exit 1
            ;;
    esac
    shift
done

# ---- 必須環境変数チェック --------------------------------------------------

if [[ -z "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
    echo "Error: CLAUDE_PLUGIN_ROOT is not set." >&2
    exit 1
fi

STATUSLINE_COMMAND="${CLAUDE_PLUGIN_ROOT}/scripts/statusline-command.sh"

# ---- スコープ解決 ----------------------------------------------------------

if [[ -n "$TARGET" ]]; then
    # 明示的指定を優先
    case "$TARGET" in
        user)
            SETTINGS_FILE="${HOME}/.claude/settings.local.json"
            ;;
        project-local)
            if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
                echo "Error: CLAUDE_PROJECT_DIR is not set." >&2
                exit 1
            fi
            SETTINGS_FILE="${CLAUDE_PROJECT_DIR}/.claude/settings.local.json"
            ;;
        project-shared)
            if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
                echo "Error: CLAUDE_PROJECT_DIR is not set." >&2
                exit 1
            fi
            SETTINGS_FILE="${CLAUDE_PROJECT_DIR}/.claude/settings.json"
            ;;
    esac
else
    # 自動検出: まず ユーザー vs プロジェクトスコープを判定
    home_normalized="${HOME%/}"
    plugin_normalized="${CLAUDE_PLUGIN_ROOT%/}"

    if [[ "$plugin_normalized" == "$home_normalized"/* ]] || \
       [[ "$plugin_normalized" == "$home_normalized" ]]; then
        # ユーザースコープ
        SETTINGS_FILE="${HOME}/.claude/settings.local.json"
    elif [[ -n "${CLAUDE_PROJECT_DIR:-}" ]]; then
        project_normalized="${CLAUDE_PROJECT_DIR%/}"
        if [[ "$plugin_normalized" == "$project_normalized"/* ]] || \
           [[ "$plugin_normalized" == "$project_normalized" ]]; then
            # プロジェクトスコープ: 既存ファイルを解析して local vs shared を判定
            shared_file="${CLAUDE_PROJECT_DIR}/.claude/settings.json"
            local_file="${CLAUDE_PROJECT_DIR}/.claude/settings.local.json"

            has_statusline_in_shared=false
            has_statusline_in_local=false

            if [[ -f "$shared_file" ]] && jq -e '.statusLine' "$shared_file" > /dev/null 2>&1; then
                has_statusline_in_shared=true
            fi
            if [[ -f "$local_file" ]] && jq -e '.statusLine' "$local_file" > /dev/null 2>&1; then
                has_statusline_in_local=true
            fi

            if $has_statusline_in_shared && ! $has_statusline_in_local; then
                # チーム共有ファイルにのみ存在 → shared を継続
                SETTINGS_FILE="$shared_file"
            else
                # ローカルにある場合・両方ある場合・どちらにもない場合 → local をデフォルト
                SETTINGS_FILE="$local_file"
            fi
        else
            # どちらでもない → フォールバック
            echo "Warning: CLAUDE_PLUGIN_ROOT is not under HOME or CLAUDE_PROJECT_DIR. Defaulting to user scope." >&2
            SETTINGS_FILE="${HOME}/.claude/settings.local.json"
        fi
    else
        # CLAUDE_PROJECT_DIR 未設定 → ユーザーへフォールバック
        SETTINGS_FILE="${HOME}/.claude/settings.local.json"
    fi
fi

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
