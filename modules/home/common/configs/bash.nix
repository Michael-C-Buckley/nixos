{config, ...}: {
  flake.modules.homeManager.bash = {pkgs, ...}: {
    home.file = {
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
    };
  };
}
