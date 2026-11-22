# ── Prompt ───────────────────────────────────────────────────────────────────
# Starship when it is installed, otherwise Nushell's default prompt. Starship
# reads $STARSHIP_CONFIG (set by the Nix wrapper) or ~/.config/starship.toml.
# This follows `starship init nu`, plus vi-mode indicators.

if (which starship | is-not-empty) {
    $env.STARSHIP_SHELL = "nu"
    $env.STARSHIP_SESSION_KEY = (random chars --length 16)

    $env.PROMPT_COMMAND = {||
        # CMD_DURATION_MS holds the placeholder "0823" until the first command runs
        let duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS }
        (
            ^starship prompt
                --cmd-duration $duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                --jobs (job list | length)
        )
    }
    $env.PROMPT_COMMAND_RIGHT = ""
    $env.PROMPT_MULTILINE_INDICATOR = (^starship prompt --continuation)

    # Starship's character module draws the emacs-mode indicator
    $env.PROMPT_INDICATOR = ""
    $env.PROMPT_INDICATOR_VI_INSERT = {||
        let color = if $env.LAST_EXIT_CODE == 0 { ansi green_bold } else { ansi red_bold }
        $"($color)❯(ansi reset) "
    }
    $env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi yellow_bold)●(ansi reset) "
}

# Earlier prompts collapse to a dim ❯ once their command has run
$env.TRANSIENT_PROMPT_COMMAND = {|| "" }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $"(ansi dark_gray_bold)❯ (ansi reset)"
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""
