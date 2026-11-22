# ── Commands ─────────────────────────────────────────────────────────────────

# Whether NAME is an external command. `which` alone would also match the
# custom commands below that share a name with the program they wrap.
def __has-external [name: string]: nothing -> bool {
    which --all $name | where type == external | is-not-empty
}

# Find files by name
def ff [pattern: string] {
    ls **/*
    | where name =~ $pattern
}

# Quick HTTP GET and pretty-print JSON
def jget [url: string] {
    http get $url | to json | print
}

# Rows whose COLUMN contains VALUE
def contains [column: string, value: string]: table -> table {
    where {|row| $row | get $column | into string | str contains $value }
}

# Show PATH as a list (much more readable)
def show-path [] {
    $env.PATH | each {|p| print $p }
}

# Process search shorthand
def pg [pattern: string] {
    ps | where name =~ $pattern
}

# Create a directory and change into it
def --env mkcd [path: path] {
    mkdir $path
    cd $path
}

# vim runs the best editor available: nvim, hx, vim, then vi
def --wrapped vim [...args] {
    let editor = [nvim hx vim vi] | where {|cmd| __has-external $cmd } | get -o 0
    if $editor == null {
        error make { msg: "vim: no editor found" }
    }
    ^$editor ...$args
}

# Sudo shim that works across my systems with no dependency on state
def --wrapped sudo [...args] {
    if (__has-external sudo) {
        ^sudo ...$args
    } else if (__has-external doas) {
        ^doas ...$args
    } else {
        error make { msg: "sudo: neither sudo nor doas is installed" }
    }
}

# Use rootbeer's bundled rb binary if it isn't already on PATH
def --wrapped rb [...args] {
    let local_rb = $nu.home-dir | path join ".rootbeer/bin/rb"
    if (__has-external rb) {
        ^rb ...$args
    } else if ($local_rb | path exists) {
        ^$local_rb ...$args
    } else {
        error make { msg: "rb: not on PATH or in ~/.rootbeer/bin" }
    }
}
