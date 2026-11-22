# Shared shell definitions

Plain files that both Zsh and Fish read at startup, so a definition lives in
one place and works without Nix.

| File | Applied with |
| --------------- | ----------------------------------------- |
| `abbreviations` | `abbr -S` (zsh-abbr), `abbr --add` (Fish) |
| `aliases` | `alias`, if the value's command exists |

## Format

One `NAME=VALUE` entry per line. The value is everything after the first `=`,
taken literally, so it needs no quoting. Whitespace around the name and value
is trimmed. Blank lines and lines starting with `#` are ignored. A `#` later in
a line is part of the value.

## Lookup

Each shell reads `$SHELL_COMMON_DIR/<file>`. When `SHELL_COMMON_DIR` is unset,
it defaults to `${XDG_CONFIG_HOME:-$HOME/.config}/shell`, so linking this
directory to `~/.config/shell` is enough outside Nix. The Nix packages and the
hjem module point it at the store copy instead.

## Adding a file

The readers are `_shell_common` in `zsh/zshrc` and `__shell_common` in
`fish/config.fish`. Each takes a file name and a command, and runs the command
once per entry: Zsh passes `NAME=VALUE` as one argument (the form `alias` and
`export` accept), and Fish passes `NAME VALUE` as two. For example, a shared
`env` file would need only:

```zsh
_shell_common env export
```

```fish
__shell_common env set -gx
```
