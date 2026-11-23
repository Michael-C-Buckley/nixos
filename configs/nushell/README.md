# Nushell

The interactive config is a set of autoload files. Nushell sources every
`*.nu` in `autoload/` in name order, and only for interactive shells, so
scripts, `nu -c`, and shebangs run without it.

## CLANKED

The bot came up with the design and implementation for it.
Original spec came from my requirements, the actual design was clanked too.

## Load order

1. `~/.config/nushell/env.nu`, then `config.nu`. These stay machine-local, and
   Nushell creates stubs when they are missing.
1. Vendor autoload directories, which is where `autoload/` is installed.
1. `~/.config/nushell/autoload/*.nu`. These load last, so machine-local
   overrides go here rather than in `config.nu`.

## Files

| File | Contents | Nix wrapper appends |
| --------------------- | --------------------------------------------------- | -------------------- |
| `00-env.nu` | Environment, PATH, SSH agent | `extraEnv` |
| `10-config.nu` | `$env.config` settings | `extraConfig` |
| `20-abbreviations.nu` | Shared abbreviations (`configs/shell`) and nu-only ones | `extraAbbreviations` |
| `30-commands.nu` | Small commands and the `vim`, `sudo`, and `rb` shims | |
| `40-fzf.nu` | Ctrl-R, Ctrl-T, and Alt-C widgets | |
| `45-git.nu` | `gfa`, `gfd`, `gfl`, and `gfrs` pickers | |
| `50-ssh.nu` | `sshf` host picker | |
| `60-direnv.nu` | direnv hook | |
| `61-zoxide.nu` | `z` and `zi`, with a plain cd fallback | |
| `70-completions.nu` | Carapace and Fish external completions | |
| `90-prompt.nu` | Starship and transient prompts | |

## Rules for these files

- Keep each file self-contained, with no `use` or `source` of another file by
  relative path. Nix and hjem install every file as its own symlink, and
  Nushell resolves relative paths from the symlink rather than its target.
  Commands defined in an earlier file can still be called from a later one.
- Merge into `$env.config` and append to its lists instead of replacing them,
  since `config.nu` has already run.
- Name keybindings and mark hooks so that loading a file twice replaces them
  instead of adding duplicates. A home can have both the hjem set and the
  wrapper's.
- Check for tools with `which` when the command runs, so the files work
  without Nix.

## Installing

- Nix: `packages/nushell` wraps `nu` with `NU_VENDOR_AUTOLOAD_DIR` set to the
  built autoload set. Its header lists the override arguments.
- hjem: `modules/hjem/cli/nushell.nix` links the same set into
  `~/.local/share/nushell/vendor/autoload` for the stock `nu`.
- Anywhere else: link `autoload/` to
  `~/.local/share/nushell/vendor/autoload` and `configs/shell` to
  `~/.config/shell`.
