# Shared shell definitions

Plain files that Zsh, Fish, and Nushell read at startup, so a definition lives
in one place and works without Nix.

| File | Applied with |
| --------------- | ----------------------------------------------------------------------------- |
| `abbreviations` | `abbr -S` (zsh-abbr), `abbr --add` (Fish), `$env.config.abbreviations` (Nushell) |
| `aliases` | `alias`, if the value's command exists (Zsh and Fish only) |

Nushell skips `aliases`. Its `alias` is resolved when the file is parsed, so it
cannot be defined in a loop over a file, and aliasing builtins like `ls` to eza
would replace Nushell's structured output with text.

## Format

One `NAME=VALUE` entry per line. The value is everything after the first `=`,
taken literally, so it needs no quoting. Whitespace around the name and value
is trimmed. Blank lines and lines starting with `#` are ignored. A `#` later in
a line is part of the value.

## Lookup

Each shell reads `$SHELL_COMMON_DIR/<file>`. When `SHELL_COMMON_DIR` is unset,
it defaults to `${XDG_CONFIG_HOME:-$HOME/.config}/shell`, so linking this
directory to `~/.config/shell` is enough outside Nix. The Nix packages and the
hjem modules point it at the store copy instead.

## Adding a file

The readers are `_shell_common` in `zsh/zshrc`, `__shell_common` in
`fish/config.fish`, and `__shell_common` in
`nushell/autoload/20-abbreviations.nu`. The Zsh and Fish readers take a file
name and a command, and run the command once per entry: Zsh passes
`NAME=VALUE` as one argument (the form `alias` and `export` accept), and Fish
passes `NAME VALUE` as two. The Nushell reader takes only the file name and
returns the entries as a record. For example, a shared `env` file would need
only:

```zsh
_shell_common env export
```

```fish
__shell_common env set -gx
```

```nu
load-env (__shell_common env)
```
