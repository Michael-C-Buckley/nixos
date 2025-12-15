{
  flake.modules.homeManager.alpine = {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
