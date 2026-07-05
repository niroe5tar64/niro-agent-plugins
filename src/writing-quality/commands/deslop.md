---
description: 指定された文書を認知負荷ベースのチェックリストで点検し、1 候補ずつ承認を取りながら簡素化する。意味・事実・数値は変えない。
allowed-tools: Read, Edit, Glob, Grep
---

# /deslop

`writing-quality` プラグインの `deslop` スキルを実行する。

## 必読

実行前に以下を Read すること。

- プラグインルート配下の `docs/principles.md`（チェックリストと境界条件）
- `skills/deslop/SKILL.md`（手順の正本）

プラグインルートは Claude Code が提供する base directory。取得できない場合は Glob で `**/writing-quality/docs/principles.md` を探す。

## 入力

- 引数: 対象ファイルのパス（省略時は 1 質問で確認する）

## 手順

`deslop` スキルの Step 1〜4 に従う。

1. 対象と想定読者を確認する（自明なら推定を宣言して進める）
2. チェックリストで修正候補を洗い出す
3. 影響の大きい順に 1 件ずつ「該当箇所 / カテゴリ / 修正案 / 根拠」を提示し、承認を取る
4. 承認された候補のみ適用し、最後にサマリを報告する
