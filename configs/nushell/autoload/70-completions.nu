# ── External completions ─────────────────────────────────────────────────────
# Carapace first, then Fish when Carapace has nothing. A few commands go
# straight to Fish, whose completions for them are better.

# Completions from Fish. NU_FISH_COMPLETER names the fish to run; the Nix
# wrapper points it at a plain fish, so completing doesn't load the wrapped
# fish's config.
def __fish-complete [spans: list<string>] {
    let fish = $env.NU_FISH_COMPLETER? | default "fish"
    if (which $fish | is-empty) {
        return null
    }

    ^$fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
        # Quote paths that Nushell would otherwise split or misread
        let value = $row.value
        let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any { $in in $value }
        if $need_quote and ($value | path exists) {
            let expanded = if ($value starts-with "~") { $value | path expand --no-symlink } else { $value }
            $'"($expanded | str replace --all "\"" "\\\"")"'
        } else {
            $value
        }
    }
}

# Completions from Carapace, or nothing when it isn't installed
def __carapace-complete [spans: list<string>] {
    if (which carapace | is-empty) {
        return null
    }

    CARAPACE_LENIENT=1 ^carapace $spans.0 nushell ...$spans | from json
}

$env.config.completions.external.completer = {|spans: list<string>|
    # Complete an alias as the command it expands to
    let expanded_alias = (scope aliases | where name == $spans.0 | get -o 0.expansion)
    let spans = if $expanded_alias != null {
        $spans | skip 1 | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        nu | git | asdf => (__fish-complete $spans)
        _ => {
            let result = (__carapace-complete $spans)
            if ($result | is-empty) { __fish-complete $spans } else { $result }
        }
    }
}
