# ── fzf widgets ──────────────────────────────────────────────────────────────
# Ctrl-R searches history, Ctrl-T inserts a file, and Alt-C changes directory,
# matching the Fish and Zsh bindings. Each widget does nothing without fzf.
#
# fzf exits non-zero when cancelled, which Nushell raises as an error, so each
# picker runs inside `try` and treats that as an empty selection.

# Search command history with fzf and replace the current command line
def fzf-history [] {
    if (which fzf | is-empty) {
        return
    }

    let selection = try {
        history
        | get command
        | uniq
        | reverse
        | str join (char nl)
        | ^fzf --height 60% --reverse --border --query (commandline) --prompt "history> "
        | str trim
    } catch { "" }

    if $selection != "" {
        commandline edit --replace $selection
    }
}

# Insert a file selected with fzf at the cursor. After `git add`, pick from
# changed files with a diff preview instead.
def fzf-file [] {
    if (which fd | is-empty) or (which fzf | is-empty) {
        return
    }

    let buffer_before_cursor = (commandline | str substring 0..<(commandline get-cursor))
    let git_add_context = ($buffer_before_cursor =~ '^\s*git\s+add(?:\s|$)')
    let file = try {
        if $git_add_context {
            let git_diff_preview = if (which comview | is-not-empty) {
                "git diff --color=always -- {} | comview"
            } else {
                "git diff --color=always -- {}"
            }
            ^git ls-files -m -d -o --exclude-standard
            | ^fzf --height 60% --reverse --border --prompt "git add> " --preview $git_diff_preview --preview-window "right:60%:wrap"
            | str trim
        } else {
            ^fd --type f --hidden --follow --exclude .git .
            | ^fzf --height 60% --reverse --border --prompt "file> " --preview "bat --color=always --style=numbers --line-range=:500 -- {} 2>/dev/null" --preview-window "right:60%:wrap"
            | str trim
        }
    } catch { "" }

    if $file != "" {
        commandline edit --insert ($file | to nuon)
    }
}

# Find a file or directory and cd to it
def --env fcd [] {
    if (which fd | is-empty) or (which fzf | is-empty) {
        return
    }

    let selection = try { ^fd . | ^fzf --height 40% --reverse | str trim } catch { "" }
    if $selection != "" {
        let selected_path = ($selection | path expand)
        let destination = if (($selected_path | path type) == "dir") {
            $selected_path
        } else {
            $selected_path | path dirname
        }
        cd $destination
    }
}

# Replace rather than duplicate if this file is loaded twice
do --env {
    let bindings = [
        {
            name: fzf_history
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert]
            event: { send: executehostcommand cmd: "fzf-history" }
        }
        {
            name: fzf_file
            modifier: control
            keycode: char_t
            mode: [emacs, vi_insert]
            event: { send: executehostcommand cmd: "fzf-file" }
        }
        {
            name: fzf_cd
            modifier: alt
            keycode: char_c
            mode: [emacs, vi_insert]
            event: { send: executehostcommand cmd: "fcd" }
        }
    ]

    $env.config.keybindings = (
        $env.config.keybindings
        | where name not-in ($bindings | get name)
        | append $bindings
    )
}
