# CONTEXT.md の書式

## 構成

```md
# {コンテキスト名}

{このコンテキストが何で、なぜ存在するのかを 1〜2 文で説明}

## Language

**Order**:
{この用語が指すものを 1〜2 文で定義}
_Avoid_: Purchase, transaction

**Invoice**:
配送完了後に Customer に送る支払い依頼。
_Avoid_: Bill, payment request

**Customer**:
Order を発行する個人または組織。
_Avoid_: Client, buyer, account
```

## ルール

- **意見を持つ。** 同じ概念に複数の呼び方があるなら、最良の 1 つを選び、他は `_Avoid_` に列挙する。
- **定義は短く。** 1〜2 文以内。何で「ある」かを書く（何を「する」かではない）。
- **このプロジェクトのコンテキスト固有の語彙だけを載せる。** タイムアウト、エラー型、ユーティリティパターンのような一般プログラミング概念は、プロジェクトで多用されていても載せない。語を追加する前に問う: これはこのコンテキスト固有の概念か、一般プログラミング概念か。前者だけが対象。
- **自然なクラスタが出来たら subheading でグループ化する。** 全ての語が 1 つのまとまった領域に属するなら、平坦リストでよい。

## 単一コンテキスト vs 複数コンテキスト

**単一コンテキスト（多数派）:** リポジトリルートに `CONTEXT.md` を 1 つ置く。

**複数コンテキスト:** リポジトリルートの `CONTEXT-MAP.md` が各コンテキストの所在と関係を列挙する:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — 顧客の注文を受け付け追跡する
- [Billing](./src/billing/CONTEXT.md) — 請求書を発行し決済を処理する
- [Fulfillment](./src/fulfillment/CONTEXT.md) — 倉庫でのピッキングと配送を管理する

## Relationships

- **Ordering → Fulfillment**: Ordering が `OrderPlaced` イベントを発行し、Fulfillment がピッキングを開始する
- **Fulfillment → Billing**: Fulfillment が `ShipmentDispatched` イベントを発行し、Billing が請求書を生成する
- **Ordering ↔ Billing**: `CustomerId` と `Money` 型を共有する
```

スキルは以下で構造を推測する:

- `CONTEXT-MAP.md` があれば、それを読んでコンテキスト群を把握する
- ルートに `CONTEXT.md` だけがあれば、単一コンテキスト
- どちらも無ければ、最初の用語が固まった時点でルートに `CONTEXT.md` を遅延作成する

複数コンテキストがある場合は、現在の話題がどれに属するかを推測する。曖昧ならユーザーに確認する。
