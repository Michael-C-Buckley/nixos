{config, ...}: {
  flake.modules.homeManager.debian = {pkgs, ...}: let
    extraConfig.user.signingkey = "/home/michael/.ssh/id_ed25519_sk";
  in {
    home.file = {
      # Largely based on what was default
      ".profile".text =
        # bash
        ''
          # Bash
          if [ -n "$BASH_VERSION" ]; then
            eval $(wsl2_ssh_agent)
            export GIT_CONFIG_GLOBAL=${config.flake.wrappers.mkGitConfig {inherit pkgs extraConfig;}}

            if [ -f "$HOME./bashrc" ]; then
              . "$HOME/.bashrc"
            fi
          fi
        '';
    };
  };
}
