# writing-quality

認知科学の知見に基づいて文書の読みやすさを改善する Claude Code プラグイン。

## 背景

生成 AI の文書は、無関連情報の付加・言い換え反復・結束性の欠如・名詞化過多といった特徴により、読み手に余計な認知負荷（extraneous cognitive load）を課しやすい。

このプラグインは、認知負荷理論・談話理解研究・情報過多研究・AI 生成テキストの言語特徴研究の検証済み知見（[docs/research-basis.md](./docs/research-basis.md)）を、執筆・レビューで実際に使えるチェックリスト（[docs/principles.md](./docs/principles.md)）に翻訳して提供する。

「短くすること」自体は目的にしない。最適な冗長度・結束度は読者の既有知識に依存する（expertise reversal）ため、執筆前の読者宣言を起点に置く。

## 提供機能

| 機能 | 呼び出し | 役割 |
|---|---|---|
| `writing-quality:audience-brief` | `/audience-brief` | 執筆前に読者・目的・読後の行動を確定し「読者宣言」を作る |
| `writing-quality:deslop` | `/deslop <path>` | 執筆後の文書を認知負荷ベースのチェックリストで点検し、1 候補ずつ承認を取りながら簡素化する |

## 使い方

```
# 書き始める前に読者を確定する
/audience-brief

# 書き上がった文書を点検・簡素化する
/deslop docs/proposal.md
```

`deslop` は意味・事実・数値を変えず、修正候補を 1 件ずつ「該当箇所 / カテゴリ / 修正案 / 根拠」の形で提示して承認を取る。

## ドキュメント

- [docs/principles.md](./docs/principles.md) — 執筆原則とチェックリスト（スキルが実行時に参照する正本）
- [docs/research-basis.md](./docs/research-basis.md) — 根拠文献レポート（DOI/URL 検証済み。査読論文・プレプリント・企業調査を区別して記載）

## 今後の予定

- textlint + prh 辞書（AI 頻出表現・冗長表現）を対象プロジェクトへセットアップするインストールコマンド（statusline プラグインの install パターンに倣う）
