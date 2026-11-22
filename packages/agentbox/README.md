# Agentbox

> [!NOTE]
> This is an OCI tool, you must have a container runtime on your system to use it.

This is a tool to create an instant work environment for agents.
It is a simple wrapper tool around OCI-compatible containers.


You use the command line to spawn a new container, at the current directory, and bind it.
This allows the agent to work with the project without full filesystem access.
The container is destroyed upon exit, leaving just the bindmounts.

The base image is ubuntu and a few common dev tools are included (like nix).
Modify to suite your needs.

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
`bash packages/agentbox/agentbox.sh` directly.

Specify the image when passing engine options or a custom command. For rootless
Podman, build with `podman build` and pass `--userns=keep-id` before the image
to map your host UID and GID.

```sh
nix run path:.#agentbox -- --engine podman --agent-state ~/src/project \
  --userns=keep-id agentbox:latest bash
```

Use `--target` before the workspace to change the container path. Using the
host workspace's absolute path can keep session paths consistent between the
host and the container. Pass the engine's `--mount` or `--volume` option before
the image for additional files or persistent state.

## Agent state and Nix

The default image launch mounts existing `~/.codex`, `~/.claude`, and
`~/.pi/agent` read-write, sharing sign-ins, settings, and token updates with the
host. It mounts `~/.agents/skills` read-only and copies `~/.claude.json` into
the container home so Claude Code can replace its copy when saving. The
launcher honors `CODEX_HOME`, `CLAUDE_CONFIG_DIR`, and `PI_CODING_AGENT_DIR`.
Use `--no-agent-state` to skip these mounts, or pass `--agent-state` before the
workspace to enable them explicitly when passing engine options.

On a Linux host that runs both the engine and the Nix daemon, pass `--nix`
before the workspace to share the daemon socket and mount `/nix/store`
read-only. The daemon applies the mapped user's host permissions, including
privileges granted through `trusted-users`.
