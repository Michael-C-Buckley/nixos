$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

def create_prompt_character [] {
    let color = (if $env.LAST_EXIT_CODE == 0 { ( ansi green_bold ) } else { ( ansi red_bold) } )
    $"($color)❯(ansi reset) "
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_MULTILINE_INDICATOR = "::: "
$env.PROMPT_INDICATOR_VI_INSERT = { create_prompt_character }
$env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi yellow_bold)●(ansi reset) "


