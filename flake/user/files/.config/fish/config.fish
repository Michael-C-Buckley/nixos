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

    # Eza binds
    if command -q eza
        alias ls 'eza'
        alias ll 'eza -la -g --icons'
        alias lt 'eza --tree --level=2 --icons'
        alias tree 'eza --tree'
    end
end
