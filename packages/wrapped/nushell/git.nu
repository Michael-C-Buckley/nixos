let git_status_regex = '\s?(?P<status>[^\s]+)\s+(?P<file>[^\s]+)'

def "git-status-entries" [] {
    ^git status --porcelain
    | parse --regex $git_status_regex
}

def "nu-complete git unstaged-files" [] {
    git-status-entries
    | where status != "A"
    | get file
}

def "nu-complete git staged-files" [] {
    ^git diff --name-only --cached
    | lines
}

def "nu-complete git add-files" [] {
    ^git status --porcelain
    | parse --regex $git_status_regex
    | get file
    | str replace " -> " "\n"
    | lines
}

def "nu-complete git branches" [] {
    ^git branch --format="%(refname:short)"
    | lines
}

def "nu-complete git remotes" [] {
    ^git remote
    | lines
}

def "nu-complete git tags" [] {
    ^git tag
    | lines
}

def "nu-complete git commits" [] {
    ^git log --pretty=format:"%h %s" -n 50
    | lines
}

def "nu-complete git tracked-files" [] {
    ^git ls-files
    | lines
}

export extern "git add" [
    ...files: string@"nu-complete git unstaged-files"
]

export extern "git restore" [
    ...files: string@"nu-complete git staged-files"
]

export extern "git checkout" [
    branch?: string@"nu-complete git branches"
    ...files: string@"nu-complete git tracked-files"
]

export extern "git switch" [
    branch?: string@"nu-complete git branches"
]

export extern "git push" [
    remote?: string@"nu-complete git remotes"
    branch?: string@"nu-complete git branches"
]

export extern "git pull" [
    remote?: string@"nu-complete git remotes"
    branch?: string@"nu-complete git branches"
]

export extern "git merge" [
    branch: string@"nu-complete git branches"
]

export extern "git rebase" [
    branch?: string@"nu-complete git branches"
]

export extern "git tag" [
    name?: string@"nu-complete git tags"
]

export extern "git show" [
    object?: string@"nu-complete git commits"
]
