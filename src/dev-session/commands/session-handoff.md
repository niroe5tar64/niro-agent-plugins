---
description: 9 つの状態ファイルを統合して、実装 Agent や未来の自分に渡せる handoff.md を生成する。docs/state-files.md の 12 セクションテンプレに従って全面再生成する。深い統合判断が必要なため、可能なら高精度モデルで実行する。
allowed-tools: Read, Write, Edit, Glob, Bash(ls:*), Bash(date:*)
---

# /session-handoff

セッションの状態を統合して、引き継ぎ用 `handoff.md` を生成する。

## 必読

- プラグインルート配下の `docs/conversation-rules.md`
- プラグインルート配下の `docs/state-files.md`（`handoff.md` の 12 セクションテンプレを参照）

このコマンドは状態ファイル間の整合的な統合が必要なため、推論密度が要る。
高精度モデルで呼び出すことが望ましい（呼び出し時のモデルを継承する）。

## 入力

- 引数: `session-name`（任意）
- 無ければ最新 mtime のセッションを対象にする。

## 手順

### Step 1: 全 9 ファイルを Read

セッションディレクトリの 9 ファイルすべてを読み込む。読まずに推論しない。

### Step 2: 12 セクションへの振り分け

`docs/state-files.md` で定義されている `handoff.md` の 12 セクションテンプレに、各ファイルの内容を以下のとおり振り分ける。

| セクション | 主な出典 |
|---|---|
| Goal | `goal.md` |
| Background | `context.md` |
| Requirements | `decisions.md`（実装すべき仕様として確定したもの） |
| Non-goals | `decisions.md` の「対象外」項目、`open-questions.md` のスコープ外メモ |
| UI Behavior | `decisions.md` / `findings.md` の UI 関連 |
| Data / API | `decisions.md` / `findings.md` の API・状態関連 |
| Edge Cases | `findings.md` の例外・境界条件 |
| Acceptance Criteria | `action-items.md` から検証可能な完了条件として導出 |
| Test Cases | `findings.md` / `action-items.md` のテスト観点 |
| Implementation Notes | `current-state.md` の実装上の注意 / 既存コードの観察 |
| Open Questions | `open-questions.md` の未解決項目 |
| Assumptions | `assumptions.md` |

### Step 3: 整合性チェック

統合中に以下を検出した場合は、`handoff.md` を **生成せず** に問題点を報告して終了する。

- `goal.md` が空、または 1 行未満
- `decisions.md` が空（要件が無い状態）
- 同一論点が `decisions.md` と `open-questions.md` の両方に存在する
- `assumptions.md` の前提が `decisions.md` の決定と矛盾する

問題があれば「`/session-review` を先に実行することを推奨」と案内する。

### Step 4: `handoff.md` の全面再生成

- 既存 `handoff.md` を Write で上書きする（追記ではない）。
- 12 セクションをすべて配置する。空のセクションでも見出しを残し、本文に `(未確定)` と書く。
- 出典外の事項を創作しない。9 ファイルに記述が無い項目は `(未確定)` のまま残す。

ファイル冒頭は `# Feature Handoff: <タイトル>` 形式。タイトルは `goal.md` から導出する。

### Step 5: 元 9 ファイルへの影響

- 元の 9 ファイルは **触らない**。
- `current-state.md` の `mode` が `handoff` でなければ、`handoff` に切り替えて `updated_at` のみ更新する（内容は変えない）。

## 出力

- 生成した `handoff.md` のパス
- 12 セクション中、`(未確定)` で残ったセクションの数と一覧（あれば）
- 統合中に検出した問題（あれば、最大 3 件）

返答全体で 3〜10 行に収める。生成内容そのものは出力しない（ファイル内容を返答に貼らない）。

## 禁止

- 元 9 ファイルの削除
- 出典外の事項を創作（推測）して書き込む
- 未解決の `open-questions.md` を勝手に決定として書き込む
- `handoff.md` を追記モードで更新する（必ず全面再生成）
- 実装やコミットを行わない
