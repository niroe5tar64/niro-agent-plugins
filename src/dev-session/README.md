# dev-session プラグイン

AI との開発会話を「会話ログ」ではなく「作業状態」として管理するための Claude Code プラグイン。
要件定義 / 仕様整理 / 設計 / デバッグ / レビュー / テスト / PR 準備のいずれにも適用できる。

主目的は AI に長文で答えさせることではない。短い対話を通じて、曖昧な情報を少しずつ整理し、最終的に実装・レビュー・引き継ぎに使える Markdown ドキュメントへ変換することにある。

## 提供スキル

### `dev-session` - セッション運用エントリ

会話のガードレール（短文応答 / 1 質問 / 三層分離）と、9 つの状態ファイルへの写像ルールを提供する。

**特徴**

- 返答は 3〜8 行を上限とする
- 1 ターンで 1 質問だけ投下する
- 決定 / 仮説 / 未確認 / 観察結果を別ファイルに分離する
- セッションは明示終了まで継続する
- 実装・コミットは行わない（必要時は `handoff.md` を別エージェントへ渡す）

## 提供コマンド

| コマンド | 役割 |
|---|---|
| `/session-start [name]`   | セッション開始。`docs/ai-sessions/{name}/` に 9 ファイルを作成し、最初の 1 質問を出す |
| `/session-update [name]`  | 直前の会話を決定/仮説/未確認/観察結果に分類して状態ファイルに反映 |
| `/session-review [name]`  | 矛盾・漏れ・危険な前提を最大 5 件抽出（高精度モデル推奨） |
| `/session-handoff [name]` | 9 ファイルを統合して 12 セクションの `handoff.md` を生成（高精度モデル推奨） |
| `/session-resume [name]`  | `current-state.md` を読んで 3〜8 行で復帰サマリと次の 1 質問を提示 |

`name` を省略した場合は最新 mtime のセッションを自動選択する（`/session-start` を除く）。

## セッションディレクトリ規約

```
docs/ai-sessions/{session-name}/
├─ goal.md            # ゴールと成果物（1〜3 行）
├─ context.md         # 既存仕様・関連 Issue・前提
├─ current-state.md   # 現モードと進捗（frontmatter に mode/updated_at）
├─ decisions.md       # 確定した決定事項（仮説・未確認は混ぜない）
├─ assumptions.md     # 仮置きの前提
├─ open-questions.md  # 未確認・未解決の論点
├─ findings.md        # 調査・観察結果
├─ action-items.md    # ユーザー側の TODO・確認事項
└─ handoff.md         # /session-handoff でのみ全面再生成
```

`{session-name}` は kebab-case 推奨（例: `purchase-button-visibility`、`login-redirect-debug`）。

各ファイルの詳細仕様と雛形は [`docs/state-files.md`](./docs/state-files.md) を参照。
会話ガードレールは [`docs/conversation-rules.md`](./docs/conversation-rules.md) を参照。

## 典型フロー

```
1. /session-start で開始
2. 短文会話で情報を整理する
3. /session-update で状態ファイルを更新する
4. 必要に応じて /session-review で矛盾・漏れを確認する
5. 未確認事項を潰していく
6. /session-handoff で引き継ぎ資料を作る
7. 実装 Agent または未来の自分に handoff.md を渡す
```

中断した場合は `/session-resume` で復帰する。

## ディレクトリ構成

```
dev-session/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── dev-session/
│       └── SKILL.md
├── commands/
│   ├── session-start.md
│   ├── session-update.md
│   ├── session-review.md
│   ├── session-handoff.md
│   └── session-resume.md
├── docs/
│   ├── conversation-rules.md
│   └── state-files.md
└── README.md
```

## 既存プラグインとの違い

| 観点 | git-ops 等の既存スキル | dev-session |
|---|---|---|
| 性質 | 単発タスク実行（コミット作成 等） | 継続的な会話状態管理 |
| 終了条件 | タスク完了で即終了 | ユーザーが終了宣言するまで継続 |
| 出力長 | 完了報告は最小（コミット ID 等） | 全ターンで 3〜8 行制約、質問は 1 つだけ |
| ファイル操作 | git index / settings 等限定 | `docs/ai-sessions/` 配下に 9 ファイルを持続更新 |
| 想定モデル | haiku（軽量） | 通常会話は軽量、review/handoff のみ高精度推奨 |

## モデル使い分け

各コマンドの frontmatter では `model` を明示しない。呼び出し時のモデルを継承する運用とする。

推奨:

- 通常会話 / `/session-start` / `/session-update` / `/session-resume`: 軽量モデル（haiku 等）
- `/session-review` / `/session-handoff`: 高精度モデル（opus 等）

会話テンポを保つため、軽量モデルを基本とし、深い推論が必要な場面のみ `/model` で切り替える。

## 使い方

プラグインを有効化したあと、Claude Code で `/session-start` を実行するだけで開始できる。
セッションファイルは git コミット対象に含めて、チームでレビュー・引き継ぎに使うことを想定している。
