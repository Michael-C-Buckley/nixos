# ── Environment ──────────────────────────────────────────────────────────────

$env.config = {
    show_banner: false

    buffer_editor: "vim"

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: true
    }

    table: {
        mode: heavy
        index_mode: always
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 50
        }
    }

    cursor_shape: {
        emacs: line
        vi_insert: line
        vi_normal: block
    }

    #color_config.shape_external: { fg: "yellow" attr: "b" }

    edit_mode: vi

    shell_integration: {
        osc2: true              # set terminal title
        osc7: true              # notify terminal of cwd
        osc9_9: false
        osc133: true            # shell prompt markers (for terminal apps)
        osc633: true
        reset_application_mode: true
    }

    render_right_prompt_on_last_line: false

    hooks: {
        pre_prompt: [{ null }]
        pre_execution: [{ null }]
    }

    keybindings: [
        {
            # currently kitty sends this for backspace, but h also works and is agreeable
            name: backspace_kill_word
            modifier: control
            keycode: char_h
            mode: [emacs, vi_insert, vi_normal]
            event: { edit: backspaceword }
        }
    ]
}

# ── Useful Custom Commands ────────────────────────────────────────────────────

# Find files by name
def ff [pattern: string] {
    ls **/*
    | where name =~ $pattern
}

# Quick HTTP GET and pretty-print JSON
def jget [url: string] {
    http get $url | to json | print
}

# Grep-like search in structured data
def contains [col: string, val: string] {
    where ($col | str contains $val)
}

# Show PATH as a list (much more readable)
def show-path [] {
    $env.PATH | each { |p| print $p }
}

# Process search shorthand
def pg [pattern: string] {
    ps | where name =~ $pattern
}


# ── Direnv ──────────────────────────────────────────────────────────────────────

use std/config *

# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) {
    # If direnv isn't installed, do nothing
    return
  }

  direnv export json | from json | default {} | load-env
  # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]

# ── Extra ──────────────────────────────────────────────────────────────────────
# Sudo shim that is universally compatible across my systems with no dependency on state
def sudo [...args] {
  if (which ^sudo | is-not-empty) {
    ^sudo ...$args
  } else if  (which ^doas | is-not-empty ) {
    doas ...$args
  } else {
    echo "nushell: sudo and doas not found"
  }
}
# Load any extra components via a host file
const hostfile = "~/.config/nushell/host.nu"
if ($hostfile | path exists) {
    source $hostfile
}

let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

# This section will be anything merged it when nix handles this file

