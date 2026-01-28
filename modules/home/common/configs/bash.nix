{
  flake.modules.homeManager.bash = {
    home.file = {
      ".config/bash/extra".text =
        #sh
        ''
          eval $(direnv hook bash)
          eval $(fzf --bash)

          export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
          export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
        '';
    };
  };
}
