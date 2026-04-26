# git-ops プラグイン

Git操作を効率化するためのClaude Codeプラグイン。

## 提供スキル

### `git-ops:bulk-commit-ja` - 日本語prefixコミット

ステージされた変更から、軽量な手順でコミットメッセージを生成し、Conventional Commits の prefix 付き日本語 subject でコミットします。

**特徴**

- トークン使用量を最小限に抑える軽量な手順
- 変更規模に応じた適応的な差分読み取り
- `<type>: <日本語subject>` 形式でのメッセージ生成
- 混在した変更の検出とステージ見直し提案

### `git-ops:git-split-commit-ja` - 変更分割コミット

大きな差分を目的別の小さなコミットへ分割し、各コミットを Conventional Commits の prefix 付き日本語 subject で作成します。

**特徴**

- 複数目的の変更を意味のある単位に分割
- 2〜7コミットを目安とした分割計画の自動作成
- 全コミットで統一された日本語prefix形式

## コミットメッセージ形式

```
<type>: <日本語subject>

- 変更点（必要な場合）

Co-Authored-By: <co-author>
```

**対応するtype**: `feat` / `fix` / `refactor` / `docs` / `style` / `test` / `chore` / `perf`

## ディレクトリ構成

```
git-ops/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── bulk-commit-ja/
│   │   ├── SKILL.md
│   │   └── scripts/
│   │       └── ai_commit.sh
│   └── git-split-commit-ja/
│       ├── SKILL.md
│       └── scripts/
│           ├── ai_commit.sh
│           └── split_inspect.sh
└── README.md
```

## 使い方

スキルはClaude Codeが自動的に呼び出します。`git-ops`プラグインをインストールすることで利用可能になります。
