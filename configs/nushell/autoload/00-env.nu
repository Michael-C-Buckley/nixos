# ── Environment ──────────────────────────────────────────────────────────────
# First stage. The Nix wrapper appends its env (extraEnv) to the end of this
# file, so values set there replace the defaults below.

$env.EDITOR = "nvim"
$env.VISUAL = $env.EDITOR
$env.PAGER = "less"
$env.LESS = "-R -F -X -i"

# XDG base directories, keeping any that are already set
$env.XDG_CONFIG_HOME = $env.XDG_CONFIG_HOME? | default ($nu.home-dir | path join ".config")
$env.XDG_DATA_HOME = $env.XDG_DATA_HOME? | default ($nu.home-dir | path join ".local/share")
$env.XDG_CACHE_HOME = $env.XDG_CACHE_HOME? | default ($nu.home-dir | path join ".cache")
$env.XDG_STATE_HOME = $env.XDG_STATE_HOME? | default ($nu.home-dir | path join ".local/state")

$env.NH_FLAKE = $env.NH_FLAKE? | default ($env.XDG_CONFIG_HOME | path join "nixos")

# ── PATH ─────────────────────────────────────────────────────────────────────
# Like fish_add_path: only directories that exist, and no duplicates. An
# error here would skip the rest of this file, including the wrapper's env,
# so `path add` only runs with something to add.
use std/util "path add"
do --env {
    let dirs = [
        /opt/homebrew/sbin
        /opt/homebrew/bin
        ($nu.home-dir | path join "bin")
        ($nu.home-dir | path join ".local/bin")
    ] | where { path exists }

    if ($dirs | is-not-empty) {
        path add ...$dirs
    }
}

# ── SSH ──────────────────────────────────────────────────────────────────────
# macOS ships OpenSSH without libfido2 support. Nix-darwin owns this fixed
# socket with a nixpkgs OpenSSH agent; do not fall back to Apple's agent.
if $nu.os-info.name == "macos" {
    $env.SSH_AUTH_SOCK = ($nu.home-dir | path join ".ssh/agent/nix-fido.sock")
} else if ($env.SSH_AUTH_SOCK? | default "" | path type) != "socket" {
    let runtime_dir = $env.XDG_RUNTIME_DIR? | default $"/run/user/(^id -u | str trim)"
    let agent = [
        ($nu.home-dir | path join ".ssh/agent/custom.sock")
        ($runtime_dir | path join "ssh-agent.sock")
        ($nu.home-dir | path join ".ssh/agent/internal.sock")
    ] | where { ($in | path type) == "socket" } | get -o 0

    if $agent != null {
        $env.SSH_AUTH_SOCK = $agent
    }
}
