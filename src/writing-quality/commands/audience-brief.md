---
description: 文書を書き始める前に、想定読者・目的・読後の行動を最大 3 質問で確定し、「読者宣言」を作成する。
allowed-tools: Read, Write, Edit, Glob
---

# /audience-brief

`writing-quality` プラグインの `audience-brief` スキルを実行する。

## 必読

実行前に以下を Read すること。

- プラグインルート配下の `docs/principles.md`（§1 執筆前に決めること、§5 境界条件）
- `skills/audience-brief/SKILL.md`（手順とフォーマットの正本）

プラグインルートは Claude Code が提供する base directory。取得できない場合は Glob で `**/writing-quality/docs/principles.md` を探す。

## 入力

- 引数: これから書く文書の説明（任意。例: `/audience-brief 経営会議向けの提案資料`）

## 手順

`audience-brief` スキルの Step 1〜3 に従う。

1. 会話・既存資料から読者宣言の項目を埋め、不足分だけを 1 質問ずつ確認する（最大 3 問）
2. 読者宣言を提示して合意を得る。保存先を確認する
3. 以後の執筆を宣言に従わせる。既存ドラフトがある場合は宣言との差分を指摘し、`/deslop` を提案する
