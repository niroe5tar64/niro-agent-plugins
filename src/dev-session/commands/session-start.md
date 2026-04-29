---
description: 新しい開発セッションを開始する。docs/ai-sessions/{name}/ 配下に 9 つの状態ファイルを作成し、最初に確認すべき論点を 1 つだけ提示する。
allowed-tools: Read, Write, Edit, Glob, Bash(mkdir:*), Bash(ls:*), Bash(date:*)
---

# /session-start

新しい `dev-session` セッションを開始する。

## 必読

実行前に以下を Read すること。

- プラグインルート配下の `docs/conversation-rules.md`（会話ガードレール）
- プラグインルート配下の `docs/state-files.md`（状態ファイル仕様と雛形）

プラグインルートは Claude Code が提供する base directory。取得できない場合は Glob で `**/dev-session/docs/state-files.md` を探す。

## 入力

- 引数: `session-name`（任意。kebab-case）
- 引数が無い場合は `YYYYMMDD-HHmm-<topic>` 形式の名前を 1 つ提案し、1 質問でユーザーに確認する（複数案を並べない）。

## 手順

### Step 1: セッション名の確定

- 引数があればそれを使う。
- 無ければ `date "+%Y%m%d-%H%M"` で取得した値と会話文脈の `<topic>` を組み合わせた候補を 1 つだけ提示し、ユーザーに確認する。

### Step 2: ディレクトリ作成

- `mkdir -p docs/ai-sessions/{session-name}/` を実行。
- 既存ディレクトリがある場合は中断し、`/session-resume` を案内する。

### Step 3: 9 ファイルの初期化

`docs/state-files.md` の雛形に従って、以下を `Write` で作成する。

- `goal.md`            — 雛形のみ（中身は Step 4 で 1 質問して埋める）
- `context.md`         — 雛形のみ
- `current-state.md`   — frontmatter `mode: spec`、`updated_at` は現在日時（`date "+%Y-%m-%d %H:%M"`）
- `decisions.md`       — 見出しのみ
- `assumptions.md`     — 見出しのみ
- `open-questions.md`  — 見出しのみ
- `findings.md`        — 見出しのみ
- `action-items.md`    — 見出しのみ
- `handoff.md`         — 見出しのみ（生成は `/session-handoff` の役割）

### Step 4: 最初の 1 質問

`goal.md` を初期化するために、ユーザーへ「このセッションのゴールを 1 行で教えてください」と尋ねる。
質問は 1 つだけ。例示は最大 1 つに絞る。

## 出力

- 作成したセッションディレクトリのパス
- 作成した 9 ファイルの一覧（パスのみ、簡潔に）
- 最初の 1 質問

返答は 3〜8 行に収める。

## 禁止

- 複数の質問を同時に投下しない
- ゴール候補を勝手に確定して書き込まない（必ずユーザーの回答を待つ）
- 9 ファイル以外の追加ファイルを作らない
- `docs/ai-sessions/` 配下以外に書き込まない
- 実装やコミットを行わない
