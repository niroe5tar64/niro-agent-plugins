# Statusline Plugin

カスタムステータスラインを提供するClaude Codeプラグインです。

## 機能

リッチな情報を表示するカスタムステータスライン：

- **モデル表示**: 現在使用中のClaudeモデル（例: `claude-sonnet-4-5`）
- **ディレクトリ表示**: 現在のディレクトリ名
- **Git情報**: ブランチ名とステータスインジケーター
  - ✓ クリーン（変更なし）
  - ± 未コミットの変更あり
- **コンテキスト使用量**: 色分け表示
  - 緑: 50%未満
  - 黄: 50-80%
  - 赤: 80%以上
- **トークンカウンター**: 省略表示（例: 35k）
- **セッションコスト**: USD表示（小数点2桁）

## インストール

### このマーケットプレイスから

```bash
# ユーザースコープ（すべてのプロジェクトで利用可能）
claude plugin install statusline@niro-agent-plugins --scope user

# プロジェクトスコープ（チームで共有）
claude plugin install statusline@niro-agent-plugins --scope project
```

## 設定

インストール後、`.claude/settings.json` に以下を追加：

```json
{
  "statusLine": {
    "type": "command",
    "command": "${CLAUDE_PLUGIN_ROOT}/scripts/statusline-command.sh"
  }
}
```

## DevContainer環境での使用

このプラグインはDevContainer環境でシームレスに動作します：

1. プロジェクトスコープでプラグインをインストール
2. `${CLAUDE_PLUGIN_ROOT}` 変数が自動的に解決される
3. コンテナ内外で正しくステータスラインが表示される

## 依存関係

- `bash`
- `jq` (JSON解析用)
- `git` (ブランチ情報用)

## 表示例

```
[claude-sonnet-4-5] niro-agent-plugins | ✓ main │ 35% (35k) │ $0.12
```

## ライセンス

MIT
