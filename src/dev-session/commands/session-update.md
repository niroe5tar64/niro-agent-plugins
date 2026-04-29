---
description: 直前の会話内容を状態ファイルへ反映する。決定/仮説/未確認/観察結果に分類して該当ファイルに追記し、current-state.md を更新したうえで次の論点を 1 つだけ提示する。
allowed-tools: Read, Write, Edit, Glob, Bash(ls:*), Bash(date:*), Bash(stat:*)
---

# /session-update

直前の会話内容を状態ファイルへ写像する。

## 必読

- プラグインルート配下の `docs/conversation-rules.md`
- プラグインルート配下の `docs/state-files.md`

## 入力

- 引数: `session-name`（任意）
- 引数が無い場合は `docs/ai-sessions/` 直下から最新 mtime のディレクトリを自動選択する（`ls -td docs/ai-sessions/*/` の先頭）。
- セッションが存在しない場合は `/session-start` を案内して終了する。

## 手順

### Step 1: セッションパス特定

- 引数があれば `docs/ai-sessions/{session-name}/` を対象にする。
- 無ければ最新 mtime のディレクトリを使う。
- 対象ディレクトリの 9 ファイルを Read で読み込む。

### Step 2: 直前ターンの分類

直前のユーザー発話 + 会話文脈を、以下に分類する（複数該当する場合は分割する）。

| 分類 | 振り分け先 |
|---|---|
| ユーザーが明示的に確定したこと | `decisions.md` に追記 |
| 仮置きの前提 / 「たぶん〜」レベル | `assumptions.md` に追記 |
| 未確認 / 確認すべき論点 | `open-questions.md` に追記 |
| 確認できた事実 / 調査結果 | `findings.md` に追記 |
| ユーザー側の TODO / 確認すべき相手 | `action-items.md` に追記 |
| 背景情報 / 既存仕様 / 関連 Issue | `context.md` に追記 |

### Step 3: 重複統合

- 既存項目と意味が重複する場合は新規追加せず、既存行に補足する。
- 過去の決定・仮説の **書き換え** はせず、変更時は新しい行で「変更: ...」と履歴を残す。
- `open-questions.md` の項目が今回の会話で解決した場合は `[x]` に変更し、内容を `decisions.md` または `findings.md` へ昇格させる。

### Step 4: `current-state.md` の更新

- frontmatter の `updated_at` を `date "+%Y-%m-%d %H:%M"` の値に更新。
- 必要なら `mode` を切り替える（spec → design など）。
- 「進捗」「今扱っている論点」「次に確認すべきこと」のセクションを最新化する。
- ファイル全体は 30 行以内を目安にし、古くなった記述は剪定する。

### Step 5: 次の論点を 1 つ提示

- `open-questions.md` から優先度の高い未確認事項を 1 つだけ選び、会話で次に確認する質問として提示する。
- `open-questions.md` が空なら、`current-state.md` の「次に確認すべきこと」を尋ねる。
- 1 質問に絞る。複数の論点を一度に展開しない。

## 出力

- どのファイルに何を追記したかの 1 行サマリ（最大 5 行）
- 次の 1 質問

返答全体で 3〜8 行に収める。

## 禁止

- 三層を混在記載しない（decisions に仮説を書かない 等）
- 過去項目の勝手な書き換えをしない
- 複数質問を同時投下しない
- スコープ外の改善案を勝手に追加しない
- `handoff.md` を触らない（`/session-handoff` の役割）
- 実装やコミットを行わない
