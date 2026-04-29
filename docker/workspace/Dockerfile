FROM node:24.15.0-bookworm-slim

ARG USERNAME=dev-user

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV SHELL=/usr/bin/zsh

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    less \
    lsof \
    openssh-client \
    procps \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    ripgrep \
    tzdata \
    unzip \
    zsh \
  && mkdir -p -m 755 /etc/apt/keyrings \
  && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends gh \
  && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
  && echo "${TZ}" > /etc/timezone \
  && corepack enable \
  && git config --system --add safe.directory "/workspace" \
  && groupmod --new-name ${USERNAME} node \
  && usermod --login ${USERNAME} \
    --home /home/${USERNAME} \
    --move-home \
    --shell /usr/bin/zsh \
    node \
  && mkdir -p /home/${USERNAME}/.local/bin \
  && touch /home/${USERNAME}/.zshrc \
  && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} \
  && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}
WORKDIR /workspace

RUN curl -fsSL https://claude.ai/install.sh | bash \
  && curl -fsSL https://mise.run | sh \
  && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" \
  && echo 'if command -v mise >/dev/null 2>&1; then eval "$(mise activate zsh)"; fi' >> "$HOME/.zshrc"

CMD ["zsh"]
