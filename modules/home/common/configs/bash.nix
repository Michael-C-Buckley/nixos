{config, ...}: let
  inherit (config.flake.userModules.bash) bashrc bashProfile;
in {
  flake.modules.homeManager.bash = {pkgs, ...}: {
    home.file = {
      ".bashrc".source = bashrc;
      ".base_profile".text = bashProfile;
      ".config/bash/extra".text =
        #sh
        ''
          #!/usr/bin/env bash
          eval "$(direnv hook bash)"
          eval "$(fzf --bash)"

          alias fz='fzf --height 40% --reverse --border'

          export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
          export GIT_CONFIG_GLOBAL=${config.flake.wrappers.mkGitConfig {inherit pkgs;}}
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
