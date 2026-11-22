FROM ubuntu:26.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bubblewrap \
        ca-certificates \
        direnv \
        git \
        neovim \
        nix-bin \
        nodejs \
        npm \
        procps \
        ripgrep \
        socat \
        tmux \
        wget \
        zsh \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --global --ignore-scripts --no-audit --no-fund \
        @openai/codex@0.169.0 \
        @earendil-works/pi-coding-agent@1.5.2 \
    && npm install --global --no-audit --no-fund @anthropic-ai/claude-code@2.1.325 \
    && npm cache clean --force

COPY --from=ghcr.io/astral-sh/uv:0.13.7 /uv /uvx /usr/local/bin/

ARG AGENTBOX_UID=1000
ARG AGENTBOX_GID=1000

RUN if getent passwd ubuntu >/dev/null; then userdel --remove ubuntu; fi \
    && if ! getent group "$AGENTBOX_GID" >/dev/null; then groupadd --gid "$AGENTBOX_GID" agentbox; fi \
    && useradd --create-home --no-log-init --uid "$AGENTBOX_UID" --gid "$AGENTBOX_GID" --shell /bin/bash agentbox \
    && install -d -o agentbox -g "$AGENTBOX_GID" /workspace

ENV NIX_CONFIG="extra-experimental-features = nix-command flakes pipe-operators" \
    DISABLE_AUTOUPDATER=1

COPY --chmod=755 entrypoint.sh /usr/local/bin/agentbox-entrypoint
USER agentbox
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/agentbox-entrypoint"]
CMD ["bash"]
