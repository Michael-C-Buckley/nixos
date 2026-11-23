#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf '%s\n' 'Usage: agentbox [OPTIONS] [WORKSPACE [[RUN OPTIONS] IMAGE [COMMAND [ARG...]]]]

Bind WORKSPACE (default .) read-write at PATH (default /workspace) and start there.
Read launcher defaults from WORKSPACE/.agentbox, one option per line.
Use local agentbox:latest when no image is supplied. Remove the container
on exit unless --persist is given. Specify IMAGE when passing engine run options
or a command.

  --no-config             Ignore WORKSPACE/.agentbox (use for untrusted projects).
  --persist NAME          Keep container NAME running after you disconnect.
                          Open bash in it, creating or starting it as needed.
                          Other options apply only when NAME is created.
  --engine docker|podman  Select the engine (default: Podman if available).
  --target PATH           Set the workspace mount path.
  --bind SRC[:DST][:ro]   Bind a host path read-write, or read-only with :ro.
                          DST defaults to the host path. Repeatable.
  --bind-file FILE        Read --bind specs from FILE, one per line. Skip blank
                          and # lines. Resolve relative paths from its folder.
  --network NAME          Attach to engine network NAME, such as none or host.
  --interface IFACE       Give the container its own address on host interface
                          IFACE through a macvlan network. Requires --ip.
  --ip ADDR[/PREFIX]      Set the container address for --network or
                          --interface. PREFIX sets the --interface subnet.
  --outbound IFACE|ADDR   Keep engine networking but send traffic from IFACE or
                          ADDR (Podman: pasta binding; Docker: source NAT only).
  --no-nix                Skip sharing the host Nix daemon socket and store
                          (shared by default).
  --agent-state           Share host agent state when using engine run options.
  --no-agent-state        Skip the default agent mounts for agentbox:latest.
  --                      End launcher options.'
}

die() {
  printf 'agentbox: %s%s\n' "$config_context" "$*" >&2
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

# Set REPLY to the absolute path of existing path $1 with its directories resolved.
resolve_path() {
  local path=$1 name=
  if [[ ! -d $path ]]; then
    name=/${path##*/}
    path=${path%/*}
    path=${path:-/}
  fi
  # Keep the suffix until after substitution so a trailing newline is preserved.
  REPLY=$(CDPATH='' cd -P -- "$path" 2>/dev/null && printf '%s/.' "$PWD") || return
  REPLY=${REPLY%/.}
  REPLY=${REPLY%/}$name
  REPLY=${REPLY:-/}
}

# Add a SRC[:DST][:ro|rw] bind, resolving a relative SRC from directory $2.
add_bind() {
  local spec=$1 base=$2 source destination='' mode=''
  source=${spec%%:*}
  if [[ $spec == *:* ]]; then
    destination=${spec#*:}
    if [[ $destination == *:* ]]; then
      mode=${destination#*:}
      destination=${destination%%:*}
    elif [[ $destination == ro || $destination == rw ]]; then
      mode=$destination
      destination=
    fi
  fi
  [[ -n $source && $mode =~ ^(ro|rw)?$ ]] ||
    die "invalid bind '$spec' (use SRC[:DST][:ro|rw]; paths cannot contain colons)"

  case "$source" in
    \~ | \~/*) source=$HOME${source#\~} ;;
    /*) ;;
    *) source=$base/$source ;;
  esac
  if [[ ! -e $source ]] || ! resolve_path "$source"; then
    die "cannot access bind source: $source"
  fi
  source=$REPLY
  destination=${destination:-$source}
  [[ $destination = /* ]] ||
    die "bind destination must be an absolute container path: $destination"
  check_mount_path "$source$destination"

  [[ $mode == ro ]] || mode=
  bind_mounts+=(--mount "type=bind,src=$source,dst=$destination${mode:+,ro}")
}

add_bind_file() {
  local file=$1 base=. line
  [[ -r $file && ! -d $file ]] || die "cannot read bind file: $file"
  if [[ $file == */* ]]; then
    base=${file%/*}
    base=${base:-/}
  fi
  while IFS= read -r line || [[ -n $line ]]; do
    line=${line#"${line%%[![:space:]]*}"}
    line=${line%"${line##*[![:space:]]}"}
    [[ -z $line || $line == '#'* ]] || add_bind "$line" "$base"
  done <"$file"
}

# Set REPLY to the first global IPv$1 address of host interface $2 as ADDR/PREFIX,
# or to nothing when it has none.
interface_address() {
  local -a fields
  [[ $2 =~ ^[A-Za-z0-9_.-]+$ ]] || die "invalid interface name: $2"
  command -v ip >/dev/null || die 'interface lookups need the ip command (iproute2)'
  ip link show dev "$2" >/dev/null 2>&1 || die "host interface not found: $2"
  read -r -a fields <<<"$(ip -o "-$1" addr show dev "$2" scope global)"
  REPLY=${fields[3]-}
}

# Set REPLY to the network address of IPv4 ADDR/PREFIX $1.
ipv4_subnet() {
  local prefix=${1#*/} a b c d n
  IFS=. read -r a b c d <<<"${1%/*}"
  n=$(((10#$a << 24 | 10#$b << 16 | 10#$c << 8 | 10#$d) & (0xffffffff << (32 - prefix)) & 0xffffffff))
  REPLY=$((n >> 24)).$((n >> 16 & 255)).$((n >> 8 & 255)).$((n & 255))/$prefix
}

# Attach to engine network $1, creating it with the remaining options if missing.
use_network() {
  local name=$1
  shift
  if ! "$engine" network inspect "$name" >/dev/null 2>&1; then
    "$engine" network create "$@" "$name" >/dev/null ||
      die "could not create $engine network $name"
    printf 'agentbox: created %s network %s (remove it with: %s network rm %s)\n' \
      "$engine" "$name" "$engine" "$name" >&2
  fi
  run_options+=(--network "$name")
}

config_context=
engine=
persist=
target=/workspace
mount_nix=true
agent_state=auto
bind_mounts=()
network_flag=
network=
address=
ipv4_pattern='^[0-9]{1,3}(\.[0-9]{1,3}){3}$'
ipv4_cidr_pattern='^[0-9]{1,3}(\.[0-9]{1,3}){3}(/([0-9]|[12][0-9]|3[0-2]))?$'

takes_value() {
  case "$1" in
    --persist | --engine | --target | --bind | --bind-file | --network | --interface | --outbound | --ip) return 0 ;;
    *) return 1 ;;
  esac
}

# Apply a single launcher option. Relative sources use the supplied base directory.
apply_option() {
  local base=$1 option=$2 value=$3
  if takes_value "$option"; then
    [[ -n $value ]] || die "$option requires a value"
  elif [[ -n $value ]]; then
    die "unexpected value for $option: $value"
  fi
  case "$option" in
    --persist)
      [[ $value =~ ^[A-Za-z0-9][A-Za-z0-9_.-]*$ ]] ||
        die "invalid container name: $value (use letters, digits, _, ., and -)"
      persist=$value
      ;;
    --engine) engine=$value ;;
    --target) target=$value ;;
    --bind) add_bind "$value" "$base" ;;
    --bind-file)
      [[ $value = /* ]] || value=$base/$value
      add_bind_file "$value"
      ;;
    --network | --interface | --outbound)
      [[ -z $network_flag ]] || die 'use only one of --network, --interface, and --outbound'
      network_flag=$option
      network=$value
      ;;
    --ip) address=$value ;;
    --nix) mount_nix=true ;;
    --no-nix) mount_nix=false ;;
    --agent-state | --no-agent-state) agent_state=$option ;;
    *) die "unknown launcher option: $option" ;;
  esac
}

read_project_config() {
  local file=$workspace/.agentbox line option value n=0 config_context=
  [[ -e $file || -L $file ]] || return 0
  [[ -f $file && -r $file ]] || die "not a readable regular file: $file"
  printf 'agentbox: reading %s\n' "$file" >&2
  while IFS= read -r line || [[ -n $line ]]; do
    n=$((n + 1))
    line=${line#"${line%%[![:space:]]*}"}
    line=${line%"${line##*[![:space:]]}"}
    [[ -z $line || $line == '#'* ]] && continue
    option=${line%%[[:space:]]*}
    value=${line#"$option"}
    config_context="$file:$n: "
    value=${value#"${value%%[![:space:]]*}"}
    apply_option "$workspace" "$option" "$value"
  done <"$file"
}

# Find the workspace without consuming the image/command tail. Apply CLI options
# only after reading that workspace's defaults.
read_config=true
cli_network=false
cli_flags=()
cli_values=()
while (($#)); do
  case "$1" in
    --no-config)
      read_config=false
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
    -*)
      option=$1
      shift
      value=
      if takes_value "$option"; then
        [[ -n ${1-} ]] || die "$option requires a value"
        value=$1
        shift
      fi
      case "$option" in --network | --interface | --outbound) cli_network=true ;; esac
      cli_flags+=("$option")
      cli_values+=("$value")
      ;;
    *) break ;;
  esac
done

workspace_input=${1-.}
if (($#)); then shift; fi
[[ -n $workspace_input ]] || die 'workspace must be a directory'
[[ $workspace_input = /* ]] || workspace_input=./$workspace_input
if [[ ! -d $workspace_input ]] || ! resolve_path "$workspace_input"; then
  die "cannot access workspace directory: $workspace_input"
fi
workspace=$REPLY
if [[ $read_config == true ]]; then read_project_config; fi
if [[ $cli_network == true ]]; then
  # Replacing the project network also drops its IP unless the CLI supplies one.
  network_flag=
  address=
fi
for i in "${!cli_flags[@]}"; do
  apply_option . "${cli_flags[i]}" "${cli_values[i]}"
done

[[ $target = /* ]] || die 'target must be an absolute container path'
case "$network_flag:$address" in
  --interface:) die '--interface requires --ip with the container address' ;;
  --interface:*)
    [[ $address =~ $ipv4_cidr_pattern ]] ||
      die "--interface needs an IPv4 --ip address, optionally with /PREFIX: $address"
    ;;
  --network:?*)
    [[ $address =~ $ipv4_pattern || ($address == *:* && $address != */*) ]] ||
      die "invalid --ip address (omit the prefix with --network): $address"
    ;;
  *:?*) die '--ip requires --network or --interface' ;;
esac

if (($# == 0)); then
  set -- agentbox:latest
fi

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

# Pass the host terminal type so programs such as tmux use its capabilities
# instead of the engine's TERM=xterm default.
terminal_options=()
if [[ -t 0 && -t 1 ]]; then
  terminal_options=(--tty)
  for name in TERM COLORTERM; do
    [[ -z ${!name-} ]] || terminal_options+=(--env "$name=${!name}")
  done
fi

# Replace the launcher with a new bash session in the persistent container.
enter_container() {
  exec "$engine" exec --interactive ${terminal_options[@]+"${terminal_options[@]}"} "$persist" bash
}

# Reuse an existing persistent container before any setup that has side effects.
if [[ -n $persist ]] &&
  container_state=$("$engine" container inspect "$persist" \
    --format '{{.State.Running}} {{index .Config.Labels "agentbox.workspace"}}' 2>/dev/null); then
  [[ ${container_state#* } == "$workspace" ]] ||
    die "container $persist was not created by agentbox --persist for $workspace; use another name"
  if [[ ${container_state%% *} != true ]]; then
    "$engine" start "$persist" >/dev/null || die "could not start container $persist"
  fi
  enter_container
fi

if [[ -n $persist ]]; then
  # The image command (an interactive shell by default) idles on its own terminal
  # to keep the container up. Interactive shells ignore SIGTERM but exit on SIGHUP.
  # The init process reaps processes that disconnected sessions leave behind.
  run_options=(
    --detach --pull=never --interactive --tty --init --stop-signal SIGHUP
    --name "$persist" --label "agentbox.workspace=$workspace"
  )
else
  run_options=(--rm --pull=never --interactive ${terminal_options[@]+"${terminal_options[@]}"})
fi
# Only supply image-specific defaults when no engine options precede the image.
stock_image=false
if [[ $1 =~ ^(localhost/)?agentbox(:latest)?$ ]]; then
  stock_image=true
  if [[ $engine == podman && $EUID != 0 ]]; then
    # Otherwise the image's non-root user maps to a subordinate host UID,
    # not the account that owns the binds and connects to the Nix daemon.
    run_options+=(--userns=keep-id)
  fi
fi
if [[ -n ${HOME:-} ]] &&
  [[ $agent_state == --agent-state || ($agent_state == auto && $stock_image == true) ]]; then
  container_home=/home/agentbox
  codex_dir=$(host_agent_dir "${CODEX_HOME:-.codex}")
  claude_dir=$(host_agent_dir "${CLAUDE_CONFIG_DIR:-.claude}")
  pi_dir=$(host_agent_dir "${PI_CODING_AGENT_DIR:-.pi/agent}")

  mount_agent_path "$codex_dir" "$container_home/.codex"
  mount_agent_path "$claude_dir" "$container_home/.claude"
  # Mount the directory even on first use, so /login and later token refreshes
  # persist outside an ephemeral container. Do not change existing permissions.
  (umask 077; mkdir -p -- "$pi_dir") || die "cannot create Pi state directory: $pi_dir"
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
    die 'host Nix daemon socket or /nix/store missing; pass --no-nix to run without host Nix'
  run_options+=(
    --env NIX_REMOTE=daemon
    --mount "type=bind,src=$nix_socket_dir,dst=$nix_socket_dir,ro"
    --mount 'type=bind,src=/nix/store,dst=/nix/store,ro'
  )
fi

case "$network_flag" in
  --network) run_options+=(--network "$network") ;;
  --interface)
    interface_address 4 "$network"
    host_address=${REPLY%/*}
    if [[ $address == */* ]]; then
      ipv4_subnet "$address"
    elif [[ -n $REPLY ]]; then
      ipv4_subnet "$REPLY"
    else
      die "interface $network has no IPv4 address; give --ip as ADDR/PREFIX"
    fi
    subnet=$REPLY

    # Prefer the interface's default gateway. Otherwise use the host's own address,
    # which macvlan cannot reach, so the container stays on the subnet.
    read -r -a route <<<"$(ip -4 route show default dev "$network")"
    gateway=
    [[ ${route[1]-} != via ]] || gateway=${route[2]-}
    for candidate in "$gateway" "$host_address"; do
      gateway=
      [[ -n $candidate ]] || continue
      ipv4_subnet "$candidate/${subnet#*/}"
      if [[ $REPLY == "$subnet" ]]; then
        gateway=$candidate
        break
      fi
    done
    use_network "agentbox-$network" --driver macvlan --opt "parent=$network" \
      --subnet "$subnet" ${gateway:+--gateway "$gateway"}
    ;;
  --outbound)
    if [[ $engine == podman ]]; then
      # Bind each address family or turn it off so none falls back to the default route.
      if [[ $network =~ $ipv4_pattern ]]; then
        pasta_options=--outbound,$network,--ipv4-only
      elif [[ $network == *:* ]]; then
        pasta_options=--outbound,$network,--ipv6-only
      else
        families=
        for family in 4 6; do
          interface_address "$family" "$network"
          [[ -z $REPLY ]] || families+="$family"
        done
        case "$families" in
          46) pasta_options=--outbound-if4,$network,--outbound-if6,$network ;;
          4) pasta_options=--outbound-if4,$network,--ipv4-only ;;
          6) pasta_options=--outbound-if6,$network,--ipv6-only ;;
          *) die "interface $network has no global address" ;;
        esac
      fi
      run_options+=(--network "pasta:$pasta_options")
    else
      source_address=$network
      if [[ ! $source_address =~ $ipv4_pattern ]]; then
        [[ $source_address != *:* ]] || die 'Docker --outbound needs an IPv4 address or an interface'
        interface_address 4 "$source_address"
        [[ -n $REPLY ]] || die "interface $source_address has no IPv4 address"
        source_address=${REPLY%/*}
      fi
      use_network "agentbox-snat-$source_address" --driver bridge \
        --opt "com.docker.network.host_ipv4=$source_address"
    fi
    ;;
esac
if [[ $address == *:* ]]; then
  run_options+=(--ip6 "$address")
elif [[ -n $address ]]; then
  run_options+=(--ip "${address%/*}")
fi

# Expand bind_mounts this way so an empty array works with set -u in older Bash.
run_options+=(
  --mount "type=bind,src=$workspace,dst=$target"
  ${bind_mounts[@]+"${bind_mounts[@]}"}
  --workdir "$target"
)
if [[ -z $persist ]]; then
  exec "$engine" run "${run_options[@]}" "$@"
fi
"$engine" run "${run_options[@]}" "$@" >/dev/null || exit
printf 'agentbox: started %s container %s (remove it with: %s rm -f %s)\n' \
  "$engine" "$persist" "$engine" "$persist" >&2
enter_container
