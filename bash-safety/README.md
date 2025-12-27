# Bash Safety Plugin

Bashコマンド実行前に危険なコマンドパターンをチェックし、実行を防止するClaude Codeプラグインです。

## 機能

PreToolUseフックとして動作し、以下を実現：

- **危険なコマンドの検出**: 複数の設定ソースから`permissions.deny`パターンを収集してチェック
- **多層防御**: プラグインデフォルト + ユーザー設定 + プロジェクト設定を**すべてマージ**
- **コマンド分割解析**: `;`、`&&`、`||`で連結されたコマンドも個別にチェック
- **Fail-closed設計**: jqが無い場合や設定が読めない場合は安全側（拒否）に倒す
- **柔軟な設定**: プロジェクト/ユーザーレベルで拒否パターンを追加可能

## インストール

### このマーケットプレイスから

```bash
# ユーザースコープ（すべてのプロジェクトで利用可能）
claude plugin install bash-safety@niro-agent-plugins --scope user

# プロジェクトスコープ（チームで共有）
claude plugin install bash-safety@niro-agent-plugins --scope project
```

## 設定

### 自動設定（推奨）

**プラグインをインストールするだけで自動的に有効化されます。**手動設定は不要です。

プラグインが以下を自動的に登録：
- PreToolUseフックがBashツール呼び出し前に実行される
- `deny-check.sh` が危険なコマンドパターンをチェック
- デフォルトの30個の拒否パターンが適用される

### 2. 拒否パターンの設定（オプション）

**プラグインにはデフォルトの拒否パターンが含まれています。**追加のパターンが必要な場合のみ設定してください。

#### パターンの読み込み順序（すべてマージされます）

1. **プラグインデフォルト** (`bash-safety/config/default-deny-patterns.json`)
   - `rm -rf /`、`sudo`、危険なgit操作など、30以上の基本パターン
   - プラグインインストール時に自動的に適用

2. **ユーザー設定** (`~/.claude/settings.json`)
   - 個人的に追加したい拒否パターン
   - すべてのプロジェクトに適用

3. **プロジェクト設定** (`.claude/settings.json`)
   - プロジェクト固有の拒否パターン
   - チームで共有可能

4. **カスタム設定** (`$CLAUDE_SETTINGS_PATH`)
   - DevContainer等で明示的に指定された設定

**重要**: これらは**すべてマージ**されます。上書きではありません。

#### 追加パターンの例

ユーザーまたはプロジェクトの `settings.json` に追加：

```json
{
  "permissions": {
    "deny": [
      "Bash(npm publish:*)",
      "Bash(docker rmi:*)",
      "Bash(:*production:*)"
    ]
  }
}
```

これらは**プラグインのデフォルトパターンに追加**されます。

## パターン構文

- `*`: 0文字以上の任意の文字列にマッチ（Bashグロブ）
- `:*`: コロンを含む任意の文字列（コマンド内の任意の位置）
- 前後の空白は自動的にトリムされます

### パターン例

| パターン | 説明 |
|---------|------|
| `rm -rf /` | 完全一致 |
| `rm -rf /*` | 完全一致 |
| `sudo :*` | sudo で始まる任意のコマンド |
| `curl :*\|:*bash:*` | curlでパイプ経由でbashを実行 |
| `:*authorized_keys:*` | authorized_keysを含む任意のコマンド |

## DevContainer環境での使用

このプラグインはDevContainer環境で特に有用です：

1. `.devcontainer/devcontainer.json` でプラグインを指定
2. チームメンバー全員が自動的に同じセキュリティポリシーを適用
3. **hooks設定は不要**（プラグインが自動登録）

```json
{
  "customizations": {
    "claude": {
      "plugins": ["bash-safety@niro-agent-plugins"]
    }
  }
}
```

必要に応じて追加の拒否パターンも設定可能：

```json
{
  "customizations": {
    "claude": {
      "plugins": ["bash-safety@niro-agent-plugins"],
      "settings": {
        "permissions": {
          "deny": [
            "Bash(:*production:*)",
            "Bash(npm publish:*)"
          ]
        }
      }
    }
  }
}
```

## Sandboxとの関係

### 多層防御の考え方

**理想的な構成（多層防御）**:
```json
{
  "sandbox": {
    "enabled": true
  }
}
```
- 第1層: bash-safety（コマンド内容チェック）
- 第2層: sandbox（実行環境の分離）

**Sandbox無効環境での防御**:
```json
{
  "sandbox": {
    "enabled": false,
    "allowUnsandboxedCommands": true
  }
}
```
- **bash-safetyが唯一の防御壁**
- DevContainer環境など、sandbox有効化が困難な場合に重要
- より厳格な拒否パターン設定を推奨

このプラグインは、sandbox無効環境での**最後の防御壁**として機能します。

## 動作

1. Claudeが Bash ツールを実行しようとする
2. deny-check.sh が実行前にフックとして起動
3. **複数のソースから拒否パターンを読み込み、マージ**
   - プラグインデフォルト設定
   - ユーザー設定 (`~/.claude/settings.json`)
   - プロジェクト設定 (`.claude/settings.json`)
   - カスタム設定 (`$CLAUDE_SETTINGS_PATH`)
4. コマンド全体と分割されたパーツをチェック
5. パターンにマッチした場合はエラーで拒否（exit 2）
6. マッチしない場合は許可（exit 0）

## 依存関係

- `bash`
- `jq` (JSON解析用、必須)

## セキュリティ上の注意

- このプラグインは**防御層の1つ**です。完全な保護を保証するものではありません
- 拒否パターンは定期的に見直してください
- jqが利用できない環境では、すべてのBashコマンドが拒否されます（Fail-closed）

## ライセンス

MIT
