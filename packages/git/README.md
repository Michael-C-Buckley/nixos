## Git

> [!NOTE]
> Git wrappers are frequently unreliable for consistency of experience, see notes below.

I ship a wrapped git which can be useful.
The wrapped `git` package loads the shared defaults after the platform's system
config. Git still reads user and repository configuration as usual. Put
machine-local settings in `~/.gitconfig` or `$XDG_CONFIG_HOME/git/config`.

## Challenges

A wrapped git packages is not a consistent experience in nix.
The typical `mkShell` for all types of nix shells override this.

A more durable change is to set `$GIT_CONFIG_GLOBAL` and include any items you need in your path,
such as wrapping at the shell level and not git's package.
The traditional approach of linking your files is fine too.

## Design

The wrapper reads the [shared Git config](../../configs/git/config). You can override its settings with Nix attributes.

```nix
flake.packages.${system}.git.override {
  settings = {
    "core.editor" = "hx";
    "commit.gpgSign" = false;
    "credential.helper" = [ "" "sops" ];
  };
}
```

## `git-credential-sops`

Purely exists as a helper. I sometimes have git tokens used instead of SSH keys.
They are sops protected, and this helper selects the right key based on the repo.
