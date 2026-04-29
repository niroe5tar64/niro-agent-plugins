# State Files

`dev-session` プラグインは、開発会話の内容を以下の 9 つの Markdown ファイルへ常時写像する。
SKILL.md と各コマンドはこのファイルを必読として参照する。

---

## セッションディレクトリ

```
docs/ai-sessions/{session-name}/
├─ goal.md
├─ context.md
├─ current-state.md
├─ decisions.md
├─ assumptions.md
├─ open-questions.md
├─ findings.md
├─ action-items.md
└─ handoff.md
```

`{session-name}` は kebab-case を推奨。例:

```
docs/ai-sessions/purchase-button-visibility/
docs/ai-sessions/login-redirect-debug/
docs/ai-sessions/template-editor-design/
```

---

## ファイル × コマンド責務マトリクス

| ファイル | start | update | review | handoff | resume |
|---|---|---|---|---|---|
| `goal.md`           | 作成（1 質問で初期化） | 必要時更新 | 整合チェック | 参照 → Goal | 参照のみ |
| `context.md`        | 作成（空テンプレ）     | 追記       | 整合チェック | 参照 → Background | 参照のみ |
| `current-state.md`  | 作成（mode=spec）      | 毎回更新   | 整合チェック | 参照 → Implementation Notes | 主参照 |
| `decisions.md`      | 作成（空）             | 追記（決定） | 矛盾検出   | 参照 → Requirements | 参照のみ |
| `assumptions.md`    | 作成（空）             | 追記（仮説） | 危険前提検出 | 参照 → Assumptions | 参照のみ |
| `open-questions.md` | 作成（最初の 1 件）    | 追記/解消  | 漏れ検出   | 参照 → Open Questions | 主参照 |
| `findings.md`       | 作成（空）             | 追記       | レビュー結果追記 | 参照 → Edge Cases / Test Cases | 参照のみ |
| `action-items.md`   | 作成（空）             | 追記       | 整合チェック | 参照 → Acceptance Criteria | 参照のみ |
| `handoff.md`        | 作成（空）             | 触らない   | 触らない   | 全面再生成 | 参照のみ |

---

## 各ファイルの目的と雛形

### `goal.md`

**目的**: セッションのゴールと成果物を 1〜3 行で固定する。
**想定行数**: 5〜15 行
**更新権**: `/session-start` 初期化、`/session-update` でユーザー確認後に更新可

雛形:

```md
# Goal

<このセッションで達成したいことを 1〜3 行>

## 成果物

- <例: 実装 Agent に渡せる handoff.md>
- <例: 設計メモ>
```

---

### `context.md`

**目的**: 既存仕様 / 関連画面 / 関連 Issue / チーム前提などの背景情報を集約する。
**想定行数**: 自由（ただし長文化したら箇条書きへ整理）
**更新権**: `/session-update` で会話から抽出して追記

雛形:

```md
# Context

## 既存仕様

- <既存の挙動 / 仕様>

## 関連画面・機能

- <関連する画面 / 機能>

## 関連 Issue / PR

- <Issue 番号 / PR URL>

## 前提

- <チーム内合意 / 外部仕様>
```

---

### `current-state.md`

**目的**: 現在の作業状態とモードを 1 ファイルで把握できるようにする。
**想定行数**: 10〜30 行（増えたら過去分は剪定）
**更新権**: `/session-update` で毎回更新、`/session-resume` で読み取り、`/session-start` で初期化

雛形:

```md
---
mode: spec
updated_at: <YYYY-MM-DD HH:mm>
---

# Current State

## 進捗

- <ここまでに整理できたこと>

## 今扱っている論点

- <現在ひとつだけ扱っている論点>

## 次に確認すべきこと

- <次の 1 質問 / 次のアクション>
```

`mode` の値: `spec / design / implementation / debug / review / test / handoff / resume`

---

### `decisions.md`

**目的**: 確定した決定事項のみを記録する。仮説・未確認は混ぜない。
**想定行数**: 自由（追記型）
**更新権**: `/session-update` で追記、`/session-review` で矛盾を指摘

雛形:

```md
# Decisions

- <決定事項> — <理由 / 出典>
- <決定事項> — <理由 / 出典>
```

注意:
- 仮説を書かない
- 未確認事項を書かない
- 過去の決定を書き換える場合は取り消し線で履歴を残すか、別行で「変更: ...」と追記する

---

### `assumptions.md`

**目的**: 仮置きしている前提を明示する。確認が取れたら `decisions.md` に昇格させる。
**想定行数**: 自由（追記型）
**更新権**: `/session-update` で追記、`/session-review` で危険な前提を抽出

雛形:

```md
# Assumptions

- <仮説> — <未確認の理由 / 確認方法>
- <仮説> — <未確認の理由 / 確認方法>
```

---

### `open-questions.md`

**目的**: 未確認の論点を蓄積する。会話で扱わなかった派生論点もここへ退避する。
**想定行数**: 自由（追記型、解決したら `decisions.md` または `findings.md` へ移動）
**更新権**: `/session-update` で追記/解消、`/session-review` で漏れを追加、`/session-resume` で参照

雛形:

```md
# Open Questions

- [ ] <未確認事項> — <聞くべき相手 / 確認方法>
- [ ] <未確認事項> — <聞くべき相手 / 確認方法>
```

解決済みは `[x]` にして残すか、`findings.md` / `decisions.md` へ昇格させる。

---

### `findings.md`

**目的**: 調査・確認で分かった事実を記録する。観察結果のログ。
**想定行数**: 自由（追記型）
**更新権**: `/session-update` で追記、`/session-review` でレビュー結果を追記

雛形:

```md
# Findings

- <観察された事実> — <出典: コード / ドキュメント / 確認した相手>
- <観察された事実> — <出典>

## Review Results (<YYYY-MM-DD>)

- <レビューで出た指摘 / 重大度>
```

---

### `action-items.md`

**目的**: 次にやるべきタスクを記録する（ユーザーの行動 / 確認すべき相手 / 調査タスクなど）。
**想定行数**: 自由（追記型、完了したら `[x]`）
**更新権**: `/session-update` で追記/更新

雛形:

```md
# Action Items

- [ ] <次にやること> — <担当 / 期限>
- [ ] <次にやること> — <担当 / 期限>
```

---

### `handoff.md`

**目的**: 実装 Agent / チームメンバー / 未来の自分に渡す最終ドキュメント。
**想定行数**: セッションの規模次第
**更新権**: `/session-handoff` でのみ全面再生成。他コマンドは触らない。

`handoff.md` のフォーマットは以下の 12 セクションで固定する。

```md
# Feature Handoff: <タイトル>

## Goal

<このセッションで達成したいこと>

## Background

<背景・既存仕様・関連情報>

## Requirements

<実装すべき仕様 — decisions.md から>

## Non-goals

<今回やらないこと — スコープ外>

## UI Behavior

<画面表示 / 操作 / 状態変化>

## Data / API

<必要なデータ / API / 状態 / 既存関数>

## Edge Cases

<例外条件 / 境界条件 / 注意ケース — findings.md から>

## Acceptance Criteria

<完了条件 — action-items.md から導出>

## Test Cases

<確認すべきテストケース — findings.md / action-items.md から>

## Implementation Notes

<既存コード上の注意点 / 実装方針 — current-state.md から>

## Open Questions

<まだ未確認の事項 — open-questions.md から>

## Assumptions

<仮置きしている前提 — assumptions.md から>
```

---

## 共通ルール

- すべてのファイルは UTF-8、改行は LF、日本語可。
- ファイル冒頭は必ず Markdown 見出し（`#` で始める）。
- 追記型ファイル（decisions/assumptions/open-questions/findings/action-items）は、過去項目の勝手な書き換えをしない。変更時は新しい行で履歴を残す。
- `current-state.md` のみ、frontmatter (`---`) で `mode` と `updated_at` を持つ。
- セッションディレクトリ名は kebab-case。
- 1 セッション = 1 ディレクトリ。複数の独立トピックを混ぜない。
