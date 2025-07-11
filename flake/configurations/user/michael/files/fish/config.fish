if status is-interactive
    # Remove the welcome/help greeting
    set -U fish_greeting

    # Starship
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience

    # Common other shell elements being reused
    source ~/.config/shells/aliases.sh
    source ~/.config/shells/environment.sh

    # Bat replaces Cat if available
    if command -q bat
        alias cat 'bat -p'
    end
end
