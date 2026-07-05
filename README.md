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

### [grill](./src/grill/)

プランや設計を AI に徹底的にインタビューさせるスキル集（[mattpocock/skills](https://github.com/mattpocock/skills) の日本語ポート）。

- `grill:me-ja` - 任意のプラン・設計を 1 ターン 1 質問で詰める汎用版
- `grill:with-docs-ja` - `CONTEXT.md`（ドメイン辞書）と `docs/adr/` をインラインで更新しながら詰める版

### [writing-quality](./src/writing-quality/)

認知科学の知見（認知負荷理論・談話理解・情報過多研究）に基づいて文書の読みやすさを改善するプラグイン。

- `writing-quality:audience-brief` - 執筆前に読者・目的・読後の行動を確定して「読者宣言」を作る
- `writing-quality:deslop` - 文書を認知負荷ベースのチェックリストで点検し、1 候補ずつ承認を取りながら簡素化
- 根拠文献（DOI/URL 検証済み・査読/プレプリント/企業調査を区別）を `docs/research-basis.md` として同梱

