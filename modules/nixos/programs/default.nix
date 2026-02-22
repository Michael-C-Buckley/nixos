{
  flake.modules.nixos.programs = {
    programs = {
      nano.enable = false;
      nh.enable = true;

      direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
        direnvrcExtra = ''
          warn_timeout=0
          hide_env_diff=true
        '';
      };
    };
  };
}
