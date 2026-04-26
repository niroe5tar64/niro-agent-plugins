---
name: release-version
description: プラグインのリリース手順を実行する。バージョン番号の決定・version ファイルの更新・コミット・git タグ作成・プッシュまでを一貫して行う。ユーザーが「リリースしたい」「バージョンを上げたい」「タグを切りたい」と依頼したときに使う。
model: haiku
---

# Release JA

## 目的

- バージョン管理ファイルを更新し、Conventional Commits 形式でコミットする。
- Git タグを作成してリモートへプッシュする。
- リリースに必要な手順を再現可能な形で統一する。

## このSkillの責務

- バージョン更新・コミット・タグ作成・プッシュのみを行う。
- 機能実装・コードレビュー・リファクタリングをしない。
- `TodoWrite` やリリース以外のファイル編集をしない。

---

## バージョンファイル一覧

このプロジェクトには **4つのバージョンファイル** が存在する。

| ファイル | 意味 |
|---|---|
| `package.json` | プロジェクト全体のバージョン（git タグと対応） |
| `.claude-plugin/marketplace.json` | マーケットプレイス向けメタデータ（`package.json` と同値に保つ） |
| `src/git-ops/.claude-plugin/plugin.json` | git-ops プラグイン個別バージョン |
| `src/statusline/.claude-plugin/plugin.json` | statusline プラグイン個別バージョン |

### バージョン更新ルール

- **`package.json` と `.claude-plugin/marketplace.json`** は常に同じバージョンに更新する（タグのベースになる）。
- **変更があったプラグインの `plugin.json`** を必ず更新する。
- 変更がないプラグインの `plugin.json` は更新しない。

### セマンティックバージョニング（semver）

- `patch` (x.x.**X**): バグ修正・ドキュメント修正・内部改善
- `minor` (x.**X**.0): 後方互換の新機能・スキル追加
- `major` (**X**.0.0): 破壊的変更（スキル削除・インターフェース変更）

---

## 実行手順

### Step 1: 前提確認

```bash
git status
git log --oneline -5
git tag --sort=-v:refname | head -5
```

- ワーキングツリーがクリーンであること（コミット済み）を確認する。
- 直近のタグを確認し、次のバージョンを決定する。
- クリーンでなければ「コミットしてから再実行してください」と報告して終了する。

### Step 2: 変更内容の把握

```bash
git log <最新タグ>..HEAD --oneline
```

- 前回タグ以降のコミット一覧を確認する。
- どのプラグインに変更があったか特定する。

### Step 3: バージョン番号の決定

- 変更内容から `patch` / `minor` / `major` を判断する。
- ユーザーが明示的に指定した場合はそれを優先する。
- 決定したバージョンをチャットで提示し、確認を取る。

### Step 4: バージョンファイルの更新

対象ファイルを直接編集する（`npm version` は使わない）：

1. `package.json` の `"version"` フィールドを更新する。
2. `.claude-plugin/marketplace.json` の `"version"` フィールドを `package.json` と同じ値に更新する。
3. 変更のあったプラグインの `.claude-plugin/plugin.json` の `"version"` フィールドを更新する。

### Step 5: コミット

```bash
git add package.json
git add .claude-plugin/marketplace.json
git add src/git-ops/.claude-plugin/plugin.json   # 変更した場合のみ
git add src/statusline/.claude-plugin/plugin.json # 変更した場合のみ
```

コミットメッセージは `git commit` で直接作成する（`ai_commit.sh` はステージ済み diff が必要なため）：

```bash
git commit -m "$(cat <<'EOF'
chore: バージョンを <新バージョン> へ更新

- package.json: <旧> → <新>
- marketplace.json: <旧> → <新>
- git-ops/plugin.json: <旧> → <新>（変更した場合のみ記載）
- statusline/plugin.json: <旧> → <新>（変更した場合のみ記載）
EOF
)"
```

### Step 6: タグの作成

```bash
git tag v<新バージョン>
```

- タグ名は `v` プレフィックス付き（例: `v0.1.8`）。
- `package.json` のバージョンと一致させる。

### Step 7: プッシュ（確認後）

プッシュは **必ずユーザーの確認を取ってから** 実行する。

```bash
git push origin main
git push origin v<新バージョン>
```

- コミットとタグを別々に push する。
- `git push --tags` は他タグを意図せず push するため使わない。

---

## 完了条件

- バージョンファイルが更新されコミット済みであること。
- タグが作成されていること。
- プッシュ完了後に「`v<バージョン>` リリース完了」と報告して終了する。
