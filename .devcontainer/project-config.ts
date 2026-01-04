import type { DevContainerConfig } from './shared/src/types'

export const projectConfig: DevContainerConfig = {
  name: 'Niro Agent Plugins Dev Environment',

  customizations: {
    vscode: {
      extensions: [
        // プロジェクト固有の拡張機能があればここに追加
      ],
      settings: {
        // Biomeの設定はbase.tsで既に設定済み
        // プロジェクト固有の設定があればここに追加
      },
    },
  },

  // プロジェクト固有の環境変数
  // 注: CLAUDE_SETTINGS_PATH はbase.tsで既に設定済み
  containerEnv: {
    // プロジェクト固有の環境変数があればここに追加
  },

  // postCreateCommand（bun installを追加）
  // 注: post-create.shが既に実行されているため、その後にbun installを実行
  postCreateCommand: 'bash .devcontainer/post-create.sh && bun install',
}

export default projectConfig
