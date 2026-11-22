# Configs & Config Paths

This is a mechanism for distinctly holding my raw configs for various things.
Nix is not the only consumer I intend to support, so this would allow an easier
way of referencing various components.

## Use in Nix

I created the attribute `configPaths` that contain this flake's configs directory.
There is also a function to split

This is useful for doing specific app overrides, though has some nuance on the usage:

```nix
# This will expose the entire directory 
"${configPath}/zsh/zshrc"

# This exposes the entire zsh directory
"${configPath.zsh}/zshrc"

# This evaluates to just the single file
configPath.zsh + "/zshrc"
```

Prefer the third in most use cases, as it is the most isolated.

## Fish with or without Nix

The `fish` package loads `fish/config.fish` and supplies the prompt switcher
and fzf widgets. With a system-installed Fish, you can source the shared file
from your own `config.fish`. Set `SHELL_COMMON_DIR` to the checkout's
`configs/shell` directory to load its aliases and abbreviations.

Set overrides in the login environment or in a local Fish `conf.d` file, which
runs before the shared startup. This example uses checkouts under `~/src`.

```fish
set -gx NH_FLAKE "$HOME/src/flake"
set -gx SHELL_COMMON_DIR "$HOME/src/new-flake/configs/shell"
```

Fish inherits the session's `SSH_AUTH_SOCK`. On Linux, if that socket is
unavailable, Fish tries `~/.ssh/agent/custom.sock`, then
`$XDG_RUNTIME_DIR/ssh-agent.sock`, then `~/.ssh/agent/internal.sock`. For that
lookup, `XDG_RUNTIME_DIR` defaults to `/run/user/<uid>`.
Set `XDG_CONFIG_HOME` before starting Fish to select a different startup
directory. The shared config applies XDG defaults to empty or unset values.
