#!/usr/bin/env bash

# writeShellApplication supplies Bash strict mode and the required tools.
: "${XDG_RUNTIME_DIR:?Hyprland needs an XDG runtime directory}"
: "${HYPRLAND_INSTANCE_SIGNATURE:?Run this from a Hyprland session}"
umask 077
session_dir="$XDG_RUNTIME_DIR/hjem-hyprland/$HYPRLAND_INSTANCE_SIGNATURE"
mkdir -p "$session_dir"
exec 9>"$session_dir/exec-once.lock"
flock -n 9 || exit 0

# Each background job has its own process group, including its descendants.
# Keep the lock in this supervisor only, so a failed child cannot retain it.
set -m
children=()
cleanup() {
	trap - EXIT
	for pid in "${children[@]}"; do
		kill -- "-$pid" 2>/dev/null || true
	done
	for pid in "${children[@]}"; do
		wait "$pid" 2>/dev/null || true
	done
}
trap cleanup EXIT
trap 'exit 0' HUP INT TERM

# The event socket closes when this compositor exits, including after a crash.
# Connect before starting applications; no shutdown command or PID file is needed.
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" OPEN:/dev/null 9>&- &
monitor=$!
children+=("$monitor")
for command in "$@"; do
	bash -c "$command" 9>&- >>"$session_dir/exec-once.log" 2>&1 &
	children+=("$!")
done
wait "$monitor" || true
