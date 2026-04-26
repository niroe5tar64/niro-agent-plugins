#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

# Claude Code
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash -s stable
fi

# mise (toolchain manager)
if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi

mise trust --yes .mise.toml
mise install

# mise activation for zsh
ZSHRC="$HOME/.zshrc"
if ! grep -q 'mise activate zsh' "$ZSHRC" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSHRC"
  echo 'eval "$(mise activate zsh)"' >> "$ZSHRC"
fi

# repo scaffold
mkdir -p .claude/rules .claude/skills .claude/agents

# Verify git user config (mounted from host ~/.gitconfig via devcontainer.json)
GIT_EMAIL=$(git config --global user.email 2>/dev/null || true)
GIT_NAME=$(git config --global user.name 2>/dev/null || true)
if [ -z "$GIT_EMAIL" ] || [ -z "$GIT_NAME" ]; then
  echo ""
  echo "⚠️  Git user info is not configured."
  echo "   Run the following on your HOST machine, then rebuild the DevContainer:"
  echo ""
  echo "     git config --global user.email \"you@example.com\""
  echo "     git config --global user.name  \"Your Name\""
  echo ""
fi

# Install dependencies
mise exec -- bun install
