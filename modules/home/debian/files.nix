{
  flake.modules.homeManager.debian = {
    home.file = {
      # Largely based on what was default
      ".profile".text =
        # bash
        ''
          if [ -n "$BASH_VERSION" ]; then
            export SSH_AUTH_SOCK="/home/michael/.ssh/ssh-agent.sock"

            if [ -f "$HOME./bashrc" ]; then
              . "$HOME/.bashrc"
            fi
          fi
        '';

      ".bash_profile".text =
        # bash
        ''
          #!/usr/bin/env bash
          if [ -f ~/.bashrc ]; then
            . ~/.bashrc
          fi
        '';

      ".config/bash/fish".text =
        # bash
        ''
          #!/usr/bin/env bash
          # If this is an interactive shell, replace it with fish
          case $- in
            *i*)
              if [ -z "$FISH_VERSION" ] && command -v fish >/dev/null 2>&1; then
                exec fish
              fi
              ;;
          esac
        '';
    };
  };
}
