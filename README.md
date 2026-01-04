# niro-agent-plugins

Claude Code向けのプラグイン集。

## インストール方法

```
/plugin marketplace add niroe5tar64/niro-agent-plugins
```

## 含まれるプラグイン

### [git-ops](./git-ops/)

Git操作を効率化するプラグイン。

- `/commit` - ステージされた変更から適切なコミットメッセージを生成

### [decision-support](./decision-support/)

意思決定を支援するプラグイン。

- `/discussion` - 1対1の壁打ちで思考を整理
- `/discussion-forum` - 複数ロールによる多角的な議論

### [statusline](./statusline/)

カスタムステータスラインを提供するプラグイン。

- モデル・ディレクトリ・Git情報・コンテキスト使用量・コストを表示

### [bash-safety](./bash-safety/)

Bashコマンド実行前の安全性チェックを行うプラグイン。

- 危険なコマンドパターンを検出して実行を防止
- 多層防御: プラグインデフォルト + ユーザー設定 + プロジェクト設定をマージ
