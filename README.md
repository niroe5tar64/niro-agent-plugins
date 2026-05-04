# niro-agent-plugins

Claude Code向けのプラグイン集。

## インストール方法

```
/plugin marketplace add niroe5tar64/niro-agent-plugins
```

## 含まれるプラグイン

### [git-ops](./src/git-ops/)

Git操作を効率化するプラグイン。

- `git-ops:bulk-commit-ja` - ステージされた変更から日本語prefix付きコミットメッセージを生成
- `git-ops:split-commit-ja` - 大きな差分を目的別の小さなコミットへ分割

### [statusline](./src/statusline/)

カスタムステータスラインを提供するプラグイン。

- モデル・ディレクトリ・Git情報・コンテキスト使用量・コストを表示

### [dev-session](./src/dev-session/)

AIとの開発会話を作業状態として管理するセッション運用プラグイン。

- 短文応答・1質問運用・決定/仮説/未確認の三層分離
- `docs/ai-sessions/{name}/` に状態ファイルを継続的に写像
- `/session-start` `/session-update` `/session-review` `/session-handoff` `/session-resume` の5コマンドを提供

