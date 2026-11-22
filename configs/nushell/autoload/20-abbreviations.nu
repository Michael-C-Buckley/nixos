# ── Abbreviations ────────────────────────────────────────────────────────────
# Fish-style: they expand inline on space or enter, and history keeps the
# expanded form. Shared with Zsh and Fish (configs/shell/README.md); only
# entries that depend on Nushell itself live here. The Nix wrapper appends its
# extraAbbreviations to the end of this file.

$env.SHELL_COMMON_DIR = $env.SHELL_COMMON_DIR? | default ($env.XDG_CONFIG_HOME | path join "shell")

# __shell_common FILE: the NAME=VALUE entries of $SHELL_COMMON_DIR/FILE as a
# record. A missing file is not an error.
def __shell_common [file: string]: nothing -> record {
    let path = $env.SHELL_COMMON_DIR | path join $file
    if not ($path | path exists) {
        return {}
    }

    # Skip blank lines, comments, and lines without a name before `=`
    open --raw $path
    | lines
    | parse --regex '^\s*(?<name>[^#\s=][^=]*?)\s*=\s*(?<value>.*?)\s*$'
    | reduce --fold {} {|entry, acc| $acc | upsert $entry.name $entry.value }
}

$env.config.abbreviations = (
    $env.config.abbreviations? | default {}
    | merge (__shell_common abbreviations)
    | merge {
        fg: "job unfreeze"
        fenv: "$env"            # Nushell's `set --show`
        ll: "ls -l"             # builtin ls, so the output stays structured
        la: "ls -a"
    }
)
