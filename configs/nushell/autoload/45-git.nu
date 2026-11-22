# ── Git pickers ──────────────────────────────────────────────────────────────
# The same gfa/gfd/gfl/gfrs as configs/fish/functions.nix, sharing one helper.

# __git-pick NAME GIT_ARGS FZF_ARGS...: the lines chosen with fzf from the
# output of `git GIT_ARGS`. Cancelling fzf gives an empty list. --wrapped
# passes fzf's flags through instead of parsing them.
def --wrapped __git-pick [name: string, git_args: list<string>, ...fzf_args: string]: nothing -> list<string> {
    if (which git | is-empty) or (which fzf | is-empty) {
        error make { msg: $"($name): git and fzf are required" }
    }
    if (^git rev-parse --is-inside-work-tree | complete).exit_code != 0 {
        error make { msg: $"($name): not inside a Git work tree" }
    }

    try {
        ^git ...$git_args
        | ^fzf --height 60% --reverse --border --preview-window "right:60%:wrap" ...$fzf_args
        | str trim
        | lines
    } catch { [] }
}

# Select changed files with fzf and stage them
def gfa [] {
    let files = (__git-pick gfa [ls-files -m -d -o --exclude-standard] --multi --preview "git diff --color=always -- {}")
    if ($files | is-not-empty) {
        ^git add -A -- ...$files
    }
}

# Select a changed file with fzf and view its unstaged diff
def gfd [] {
    let file = (__git-pick gfd [ls-files -m -d] --preview "git diff --color=always -- {}")
    if ($file | is-not-empty) {
        ^git diff -- ($file | first)
    }
}

# Select a commit with fzf and show it
def gfl [] {
    let commit = (__git-pick gfl [log "--format=%C(auto)%h%x09%s%d"] --ansi --delimiter "\t" --with-nth "2.." --preview "git show --color=always {1}")
    if ($commit | is-not-empty) {
        ^git show ($commit | first | split row "\t" | first | ansi strip)
    }
}

# Select staged files with fzf and unstage them
def gfrs [] {
    let files = (__git-pick gfrs [diff --cached --name-only] --multi --preview "git diff --cached --color=always -- {}")
    if ($files | is-not-empty) {
        ^git restore --staged -- ...$files
    }
}
