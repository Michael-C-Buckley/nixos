{config, ...}: {
  flake.modules.homeManager.bash = {pkgs, ...}: {
    home.file = {
      ".config/bash/extra".text =
        #sh
        ''
          #!/usr/bin/env bash
          eval "$(direnv hook bash)"
          eval "$(fzf --bash)"

          export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
          export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
          export GIT_CONFIG_GLOBAL=${config.flake.wrappers.mkGitConfig {inherit pkgs;}}
        '';
    };
  };
}
