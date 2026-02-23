{
  flake.modules.homeManager.programs = {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
