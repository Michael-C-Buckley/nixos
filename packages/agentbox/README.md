# Agentbox

> [!NOTE]
> This is an OCI tool, you must have a container runtime on your system to use it.

This is a tool to create an instant work environment for agents.
It is a simple wrapper tool around OCI-compatible containers.

You use the command line to spawn a new container, at the current directory, and bind it.
This allows the agent to work with the project without full filesystem access.
The container is destroyed upon exit, leaving just the bindmounts, unless you
pass `--persist`.

The base image is ubuntu and a few common dev tools are included (like nix).
Modify to suite your needs.

## CLANKED

This tool is very largely clanked. I own the design and the idea, execution is
nearly entirely bot-written, especially the bash script.

## Build and run

Build the image with your host UID and GID so the container user can write to
the workspace. From the flake root, build and run it with the same engine.

```sh
docker build --build-arg AGENTBOX_UID="$(id -u)" --build-arg AGENTBOX_GID="$(id -g)" \
  -t agentbox:latest packages/agentbox
nix run path:.#agentbox -- --engine docker ~/src/project
```

Docker or Podman must be available on the host. The launcher prefers Podman when
available, uses the local `agentbox:latest` image by default, and removes the
container on exit. On a host with Bash, you can also run
`bash packages/agentbox/agentbox.sh` directly. The launcher shares the host Nix
store and daemon socket by default; use `agentbox --no-nix ~/src/project` to
skip both mounts or run on a host without Nix.

For rootless Podman, use the same build arguments with `podman build`. On a
normal `agentbox:latest` launch the wrapper adds `--userns=keep-id`, so the
image user maps to your host UID/GID. Specify the image when passing engine
options or a custom command. If passing engine options, supply the mapping
(and `--agent-state` if desired) yourself, for example:

```sh
nix run path:.#agentbox -- --engine podman --agent-state ~/src/project \
  --userns=keep-id agentbox:latest bash
```

Use `--target` before the workspace to change the container path. Using the
host workspace's absolute path can keep session paths consistent between the
host and the container. Pass the engine's `--mount` or `--volume` option before
the image for additional files or persistent state.

## Workspace defaults: `.agentbox`

Create `.agentbox` in the workspace root, then run `agentbox` there or
`agentbox /path/to/project` from elsewhere. For example:

```text
# One launcher option per line
--no-nix
--network none
--target /src
--bind ./sample data:/data:ro
```

The rest of each line after the option name is its literal value. Don't quote
paths with spaces. Blank lines and full-line `#` comments are ignored. The file
is not a shell script: there is no variable, command, or glob expansion. Relative
`--bind` sources and `--bind-file` names in the file resolve from the workspace.
As on the CLI, a `--bind` source starting with `~/` resolves from your home.

Command-line options override file defaults; binds accumulate. Selecting a
network on the CLI replaces the file's network selection and IP together. Pass
engine run options, the image, and its command on the CLI after the workspace,
not in `.agentbox`. Recreate a persistent container to change its mounts.

Review `.agentbox` before launching an unfamiliar checkout: its options can
expose host files and change networking. Use `agentbox --no-config .` to ignore
it. Only the selected workspace is checked; parent directories are not searched.

## Extra bind mounts

```sh
# DST defaults to the host path.
agentbox --bind ~/src/shared-lib --bind ~/datasets:/data:ro ~/src/project
agentbox --bind-file ~/.config/agentbox/binds ~/src/project
```

`--bind SRC[:DST][:ro]` adds a read-write bind mount, or a read-only one with
`:ro`, and keeps the default image launch and its agent state mounts. Relative
sources resolve from the current directory and `~` expands to your home
directory. DST must be an absolute container path; it defaults to the resolved
host path. `--bind-file FILE` reads one spec per line, skips blank lines and
lines starting with `#`, and resolves relative sources from the file's
directory. Both options can be repeated. Bind paths cannot contain colons,
commas, double quotes, or line breaks.

## Networking

```sh
agentbox --network none ~/src/project
agentbox --interface br1 --ip 192.168.59.20 ~/src/project
agentbox --interface br100 --ip 192.168.56.40/27 ~/src/project
agentbox --outbound 192.168.63.6 ~/src/project
```

The network options limit what the container can reach. Agentbox does not
publish ports. Use only one of `--network`, `--interface`, and `--outbound`.

- `--network NAME` attaches to an existing engine network such as `none` or
  `host`. Add `--ip ADDR` to set the container's address on a user-defined
  network.
- `--interface IFACE --ip ADDR[/PREFIX]` gives the container its own IPv4 address
  on a host interface through a macvlan network named `agentbox-IFACE`, created
  on first use. The subnet comes from the prefix or IFACE's address and the
  gateway from IFACE's default route. With no default route it uses the host's
  address on IFACE, which macvlan can't reach, so the container stays on that
  subnet. Macvlan also stops the host and the container from reaching each other
  over IFACE. An existing `agentbox-IFACE` network is reused unchanged, so create
  it yourself for other settings or remove it to have it rebuilt. This needs
  Docker or rootful Podman.
- `--outbound IFACE|ADDR` keeps the engine's NAT networking but sends traffic from
  IFACE or ADDR. Rootless Podman binds pasta to it and turns off any IP version
  it can't bind, so no traffic falls back to the default route. Docker creates a
  bridge network named `agentbox-snat-ADDR` that uses ADDR, or IFACE's first IPv4
  address, as the source address. Docker's host routing table still picks the
  outgoing interface, so pair it with routes or firewall rules for that address,
  or use `--interface` for a hard binding.

Interface names are looked up with the `ip` command at launch.

## Persistent containers

`--persist NAME` keeps the container running after you disconnect. The first
launch creates container NAME in the background and opens a Bash session in it.
Running the same command again opens another session there, starting the
container first if it stopped, such as after a reboot. Other launch and run
options apply only when the container is created, and the launcher refuses a
NAME that belongs to a different workspace. Stop the container with
`docker stop NAME` and remove it with `docker rm -f NAME`, or use the Podman
equivalents.

You can't reattach to a disconnected session, and its processes may keep running
unseen. Run agents inside the image's tmux so you can return to them:

```sh
agentbox --persist project ~/src/project
tmux new-session -A -s main  # Detach with Ctrl-b d; run both commands to return.
```

Everything in the container, including tmux, ends when it stops. Claude Code
and Codex keep conversations in the mounted host state, so `claude --continue`
and `codex resume` can pick one up in a new session.

## Terminal types

When run from a terminal, the launcher passes your `TERM` and `COLORTERM` to
each session, so tmux and other programs use your terminal's colors and
features rather than the engine's `TERM=xterm` default. The image includes
`ncurses-term` along with `xterm-kitty`, `xterm-ghostty`, and `foot-extra`,
which covers kitty, Ghostty, Alacritty, foot, WezTerm, tmux, and most other
terminals. Rebuild the image after updating the launcher, and recreate
persistent containers, or programs will report an unknown terminal. A custom
image needs a definition for your `TERM`; otherwise run
`export TERM=xterm-256color` in the session.

## Building with the host Nix daemon

```sh
agentbox .                               # on the host, from the flake root
nix store info --store daemon            # inside: verify daemon access
nix build --no-link --print-out-paths .#agentbox
```

The default launch requires a local Linux engine and a running or socket-activated
host Nix daemon. It binds `/nix/store` and `/nix/var/nix/daemon-socket` read-only
at the same paths and sets `NIX_REMOTE=daemon`. The client sends build requests
over the socket; the **host daemon** writes the results. The container needs
neither a writable store nor its own daemon. Pass `--no-nix` before the workspace
to skip both mounts and the `NIX_REMOTE` setting. Recreate an existing `--persist`
container to change its mounts.

The daemon checks the **host account for the mapped UID**, not the name
`agentbox` in the image. With ordinary rootful Docker (no user namespace
remapping), build the image with your UID/GID as above. With rootless Podman,
use the keep-id mapping described above. With other mappings, check the actual
host UID before changing permissions.

Ordinary builds need an **allowed**, not a **trusted**, user. Upstream Nix
defaults to `allowed-users = *`; this repo's `modules/nixos/system/nix.nix`
allows **and trusts** `root` and `@wheel`. A mapped wheel user therefore needs
no change, but sharing that user's socket access gives the container
root-equivalent Nix privileges on the host. Use `--no-nix` for untrusted images.
For less privilege, launch as a separate non-wheel host account with workspace
access, build the image with its IDs, and add just that account to your host
configuration (replace `builduser` with its name), then rebuild NixOS:

```nix
nix.settings.allowed-users = [ "builduser" ];
```

## Keeping agent logins

Pi's `/login` credentials live in **`~/.pi/agent/auth.json`**. The launcher
binds `${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}` on the host to
`/home/agentbox/.pi/agent` **read-write**. Bind the directory, not just the
file, so Pi can lock and update credentials during token refresh. If the
directory doesn't exist the launcher creates it private to your user. Log in
once on the host or inside the box; a new container using the same directory
picks up that login without `--persist`.

Processes in the container can read and modify everything in that directory,
including credentials. To keep container logins separate from your host Pi
profile, use e.g. `PI_CODING_AGENT_DIR=~/.local/state/agentbox/pi agentbox .`
consistently. Recreate persistent containers to change their mounts.

The default launch also mounts existing `~/.codex` and `~/.claude` read-write,
mounts `~/.agents/skills` read-only, and copies `~/.claude.json` into the
container home so Claude Code can replace its copy. The launcher honors
`CODEX_HOME` and `CLAUDE_CONFIG_DIR`. Use `--no-agent-state` to skip the agent
mounts, or `--agent-state` before the workspace to enable them explicitly when
passing engine options.
