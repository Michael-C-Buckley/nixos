#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf '%s\n' 'Usage: agentbox [OPTIONS] WORKSPACE [[RUN OPTIONS] IMAGE [COMMAND [ARG...]]]

Bind WORKSPACE read-write at PATH (default /workspace) and start there.
Use local agentbox:latest when only WORKSPACE is supplied. Remove the container
on exit by default. Specify IMAGE when passing engine run options or a command.

  --engine docker|podman  Select the engine (default: Podman if available).
  --target PATH           Set the workspace mount path.
  --nix                   Share the host Nix socket and read-only store.
  --agent-state           Share host agent state when using engine run options.
  --no-agent-state        Skip the default agent mounts for agentbox:latest.
  --                      End launcher options.'
}

die() {
  printf 'agentbox: %s\n' "$*" >&2
  exit 2
}

check_mount_path() {
  case "$1" in
    *','* | *'"'* | *$'\r'* | *$'\n'*) die 'bind paths cannot contain commas, double quotes, or line breaks' ;;
  esac
}

host_agent_dir() {
  check_mount_path "$1"
  case "$1" in
    /*) printf '%s' "$1" ;;
    *) printf '%s/%s' "$HOME" "${1#\~/}" ;;
  esac
}

mount_agent_path() {
  local source=$1 destination=$2
  if [[ -d $source || -f $source ]]; then
    check_mount_path "$source"
    run_options+=(--mount "type=bind,src=$source,dst=$destination${3-}")
  fi
}

engine=
target=/workspace
mount_nix=false
agent_state=auto

while (($#)); do
  case "$1" in
    --engine | --target)
      [[ -n ${2-} ]] || die "$1 requires a value"
      case "$1" in
        --engine) engine=$2 ;;
        --target) target=$2 ;;
      esac
      shift 2
      ;;
    --nix)
      mount_nix=true
      shift
      ;;
    --agent-state | --no-agent-state)
      agent_state=$1
      shift
      ;;
    -h | --help)
      usage
      exit
      ;;
    --)
      shift
      break
      ;;
    -*) die "unknown launcher option: $1" ;;
    *) break ;;
  esac
done

(($# >= 1)) || die 'provide a workspace (see --help)'
[[ -n $1 ]] || die 'workspace must be a directory'
[[ $target = /* ]] || die 'target must be an absolute container path'

workspace_input=$1
shift
if (($# == 0)); then
  set -- agentbox:latest
fi
[[ $workspace_input = /* ]] || workspace_input=./$workspace_input
# Keep the suffix until after substitution so a trailing newline is preserved.
workspace=$(CDPATH='' cd -P -- "$workspace_input" 2>/dev/null && printf '%s/.' "$PWD") ||
  die "cannot access workspace directory: $workspace_input"
workspace=${workspace%/.}

check_mount_path "$workspace$target"

if [[ -z $engine ]]; then
  if command -v podman >/dev/null; then
    engine=podman
  else
    engine=docker
  fi
fi
case "$engine" in
  docker | podman) ;;
  *) die 'engine must be docker or podman' ;;
esac
command -v "$engine" >/dev/null || die "$engine is unavailable (install Docker or Podman)"

run_options=(--rm --pull=never --interactive)
if [[ -t 0 && -t 1 ]]; then
  run_options+=(--tty)
fi
if [[ -n ${HOME:-} ]] &&
  [[ $agent_state == --agent-state || ($agent_state == auto && $1 =~ ^(localhost/)?agentbox(:latest)?$) ]]; then
  container_home=/home/agentbox
  codex_dir=$(host_agent_dir "${CODEX_HOME:-.codex}")
  claude_dir=$(host_agent_dir "${CLAUDE_CONFIG_DIR:-.claude}")
  pi_dir=$(host_agent_dir "${PI_CODING_AGENT_DIR:-.pi/agent}")

  mount_agent_path "$codex_dir" "$container_home/.codex"
  mount_agent_path "$claude_dir" "$container_home/.claude"
  mount_agent_path "$pi_dir" "$container_home/.pi/agent"
  mount_agent_path "$HOME/.agents/skills" "$container_home/.agents/skills" ',ro'

  claude_global="$HOME/.claude.json"
  if [[ -n ${CLAUDE_CONFIG_DIR:-} && -f $claude_dir/.claude.json ]]; then
    claude_global="$claude_dir/.claude.json"
  fi
  mount_agent_path "$claude_global" /run/agentbox/claude.json ',ro'
fi
if [[ $mount_nix == true ]]; then
  nix_socket_dir=/nix/var/nix/daemon-socket
  [[ -S $nix_socket_dir/socket && -d /nix/store ]] ||
    die '--nix requires the host Nix daemon socket and /nix/store'
  run_options+=(
    --env NIX_REMOTE=daemon
    --mount "type=bind,src=$nix_socket_dir,dst=$nix_socket_dir,ro"
    --mount 'type=bind,src=/nix/store,dst=/nix/store,ro'
  )
fi

exec "$engine" run "${run_options[@]}" \
  --mount "type=bind,src=$workspace,dst=$target" \
  --workdir "$target" "$@"
