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
        mode: heavy             # rounded | heavy | light | compact | none
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
        algorithm: "fuzzy"      # "prefix" | "fuzzy"
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
}

# ── Prompt ───────────────────────────────────────────────────────────────────

def create_left_prompt [] {
    let dir = ($env.PWD | str replace $env.HOME "~")

    let git_branch = (
        do { git rev-parse --abbrev-ref HEAD }
        | complete
        | if $in.exit_code == 0 { $"($in.stdout | str trim)" } else { "" }
    )

    let git_string = ( if $git_branch != "" {
            $"(ansi blue) git:\((ansi red)($git_branch)(ansi blue)\)"
        } else { "" }
    )

    $"(ansi cyan_bold)($dir)(ansi reset)($git_string)(ansi reset)\n"
}

def create_right_prompt [] {
    # Right prompt has a nix shell indicator and the time

    let time = (date now | format date "%H:%M:%S")

    let nix_shell = ($env | get -o IN_NIX_SHELL | default "")
    let nix_color = if $nix_shell == "pure" { "green_bold" } else { "yellow_bold" }
    let nix_icon = if $nix_shell != "" {
        ($"(ansi $nix_color)✱(ansi reset) ")
    } else { "" }

    $"($nix_icon)(ansi dark_gray)($time)(ansi reset)"
}

$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }
$env.PROMPT_INDICATOR = $"(ansi cyan_bold)❯ (ansi reset)"
$env.PROMPT_INDICATOR_VI_INSERT = $"(ansi green_bold)❯(ansi reset) "
$env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi yellow_bold)●(ansi reset) "
$env.PROMPT_MULTILINE_INDICATOR = $"::: "
$env.TRANSIENT_PROMPT_COMMAND = { "" }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = { "" }
$env.TRANSIENT_PROMPT_INDICATOR = { "" }
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

let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

# This section will be anything merged it when nix handles this file

