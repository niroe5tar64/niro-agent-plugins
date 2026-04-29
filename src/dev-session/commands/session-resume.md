---
description: 中断したセッションを再開する。current-state.md と open-questions.md を読み、現状を 3〜8 行で要約して次の論点を 1 つだけ提示する。
allowed-tools: Read, Glob, Bash(ls:*)
---

# /session-resume

中断したセッションを復帰する。

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
- 候補が複数ある場合は最新の 1 つだけ選ぶ（複数並べない）。

### Step 2: 主要ファイルを Read

以下のみを読む。全 9 ファイルをダンプしない。

- `current-state.md`（`mode`、進捗、現在の論点、次にやること）
- `open-questions.md`（未解決の論点）
- 必要に応じて `goal.md`（ゴール 1 行）

### Step 3: 3〜8 行のサマリ生成

以下の構造で簡潔に要約する。

```
セッション: <session-name>  (mode: <現モード>)

ゴール: <goal.md から 1 行>
進捗: <current-state.md から 1〜2 行>
未確認: <open-questions.md から優先 1〜2 件>
次: <次に詰めるべき 1 件>
```

### Step 4: 次の 1 質問

サマリの末尾に、次に進めるための 1 質問を添える（`open-questions.md` の優先項目から 1 つ）。
未解決が無ければ「次に進めたい論点はありますか？」と尋ねる。

## 出力

上記の構造で 3〜8 行に収める。

## 禁止

- 全 9 ファイルの内容を本文に貼り付ける
- 複数の質問を同時に投下する
- 複数のセッション候補を並べて提示する
- 実装やコミットを行わない
- ファイルへの書き込み（`/session-resume` は読み取り専用）
