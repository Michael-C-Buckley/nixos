#!/bin/sh
set -eu

# Claude Code replaces its global state file when it saves.
if [ -f /run/agentbox/claude.json ] && [ ! -e "$HOME/.claude.json" ]; then
  install -m 0600 /run/agentbox/claude.json "$HOME/.claude.json"
fi

exec "$@"
