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
