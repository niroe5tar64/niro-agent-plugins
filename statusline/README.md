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

### 1. プラグインのインストール

```bash
# ユーザースコープ（すべてのプロジェクトで利用可能）
claude plugin install statusline@niro-agent-plugins --scope user

# プロジェクトスコープ（チームで共有）
claude plugin install statusline@niro-agent-plugins --scope project
```

### 2. statusline の設定を適用する

Claude Code セッション内で以下のコマンドを実行します：

```
/install-statusline
```

これにより、プロジェクトの `.claude/settings.local.json` に `statusLine` の設定が書き込まれます。

#### すでに `statusLine` が設定されている場合

| 状況 | 挙動 |
|---|---|
| このプラグインと同じ値が設定済み | 何もしない（already configured と表示） |
| 別の値が設定されている | 警告を出してスキップ（上書きしない） |

別の値が設定されていて上書きしたい場合は、`settings.local.json` から `statusLine` を手動で削除してから再度 `/install-statusline` を実行してください。

## アンインストール

```
/uninstall-statusline
```

`settings.local.json` の `statusLine` を削除します。
このプラグインが設定した値と一致する場合のみ削除します（他の設定は変更しません）。

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
