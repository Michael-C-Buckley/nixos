def "nu-complete git add-files" [] {
    ^git status --porcelain
    | lines
    | parse "{x}{y} {file}"
    | get file
    | str replace " -> " "\n"
    | lines
}

export extern "git add" [
    ...files: string@"nu-complete git add-files"
]

export extern "git restore" [
    ...files: string@"nu-complete git add-files"
]

export extern "git checkout" [
    ...files: string@"nu-complete git add-files"
]
