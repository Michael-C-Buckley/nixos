{
  flake.modules.homeManager.debian = {
    home.file = {
      # Largely based on what was default
      ".profile".text =
        # bash
        ''
          # Ensure that binaries are readable in other sources too
          echo 'export PATH="$HOME/.nix-profile/bin:$PATH"' >> ~/.profile

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

      ".config/bash/nushell".text =
        # bash
        ''
          #!/usr/bin/env bash
          # If this is an interactive shell, replace it with nushell
          case $- in
            *i*)
              if [ -z "$NUSHELL_VERSION" ] && command -v nushell >/dev/null 2>&1; then
                exec nu
              fi
              ;;
          esac
        '';
    };
  };
}
