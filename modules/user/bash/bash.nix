{
  flake.userModules.bash = {
    bashrc = ./bashrc;

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
