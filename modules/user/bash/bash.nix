{
  flake.userModules.bash = {
    bashrc = ./bashrc.bash;

    bashProfile =
      # bash
      ''
        # Source interactive config
        if [[ -f ~/.bashrc ]]; then
          . ~/.bashrc
        fi
      '';
  };
}
