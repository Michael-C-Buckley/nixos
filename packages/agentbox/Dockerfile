# Install the agents in their own stage so npm and its dependencies stay out of
# the final image.
FROM ubuntu:26.04 AS agents

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        nodejs \
        npm

# Claude Code's postinstall copies its native binary to bin/claude.exe, so its
# platform packages are unused afterward. Ubuntu's npm installs both the glibc
# and musl ones.
RUN npm install --global --ignore-scripts --no-audit --no-fund \
        @openai/codex@0.169.0 \
        @earendil-works/pi-coding-agent@1.5.2 \
    && npm install --global --no-audit --no-fund @anthropic-ai/claude-code@2.1.325 \
    && rm -rf /usr/local/lib/node_modules/@anthropic-ai/claude-code/node_modules

FROM ubuntu:26.04

# Node.js runs Pi and the Codex launcher.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bubblewrap \
        ca-certificates \
        direnv \
        git \
        neovim \
        nix-bin \
        nodejs \
        procps \
        ripgrep \
        socat \
        tmux \
        wget \
        zsh \
    && rm -rf /var/lib/apt/lists/*

COPY --from=agents /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=agents /usr/local/bin/ /usr/local/bin/
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
