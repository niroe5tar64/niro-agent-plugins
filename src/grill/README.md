# grill プラグイン

プランや設計を AI に徹底的に「グリル」させて、決定木の全分岐を潰すまでインタビューさせるスキル集。
中〜大規模コードベース向けには、`CONTEXT.md`（ドメイン辞書）と `docs/adr/` を **インラインで更新** する版も提供する。

[mattpocock/skills](https://github.com/mattpocock/skills) の `grill-me` / `grill-with-docs` を日本語化・自己ポートしたもの。

## 提供スキル

### `grill:me-ja` — 汎用グリル

プラン・設計・運用ルールなど、コードを伴わない文脈にも使える汎用版。

- 1 ターン 1 質問
- 各質問に推奨回答を必ず添える
- コードで答えられる質問は探索を優先

### `grill:with-docs-ja` — ドキュメント連動グリル

`grill:me-ja` の進行ルールを継承しつつ、以下を追加する。

- 既存の `CONTEXT.md` 用語と突き合わせて矛盾を即指摘
- 曖昧な語に正準名を提案
- 具体シナリオでドメイン境界を詰める
- 決定が固まった瞬間に `CONTEXT.md` と `docs/adr/` をインラインで更新
- ADR は「取り消し困難 / 文脈無しでは驚く / 真のトレードオフ」3 条件全て満たす場合のみ提案

書式は同梱の [`CONTEXT-FORMAT.md`](./skills/with-docs-ja/CONTEXT-FORMAT.md) と
[`ADR-FORMAT.md`](./skills/with-docs-ja/ADR-FORMAT.md) に従う。

## 使い分け

| 観点 | `grill:me-ja` | `grill:with-docs-ja` |
|---|---|---|
| 対象 | 任意のプラン・設計・運用ルール | コードベースを伴うプロジェクト |
| ドキュメント連携 | しない | `CONTEXT.md` / `docs/adr/` を更新 |
| 用語ストレステスト | しない | 既存ドメイン辞書と突き合わせて矛盾を指摘 |
| 想定シーン | 非コード文脈、ライト用途 | 中〜大規模コードベースの設計・仕様詰め |

迷ったら `grill:me-ja` から始めて、ドメイン辞書の整備が必要だと感じた時点で `grill:with-docs-ja` に切り替える。

## ディレクトリ構成

```
grill/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── me-ja/
│   │   └── SKILL.md
│   └── with-docs-ja/
│       ├── SKILL.md
│       ├── CONTEXT-FORMAT.md
│       └── ADR-FORMAT.md
└── README.md
```

## 他プラグインとの関係

- **`dev-session`**: 状態ファイル管理が主目的のセッションスキル。`grill:me-ja` / `grill:with-docs-ja` で詰めた決定を `decisions.md` 等に写像したいときは `/session-update` を併用する。
- **`git-ops`**: コミット作成系。`grill:with-docs-ja` で `CONTEXT.md` を更新した後、コミットは `bulk-commit-ja` 等に渡す。

## 原典・ライセンス

原典: [mattpocock/skills](https://github.com/mattpocock/skills)（`productivity/grill-me`, `engineering/grill-with-docs`）

本ポートは原典のライセンスと設計思想を尊重したうえで、トリガー語と書式を日本語環境向けに最小限の加筆で翻訳している。
