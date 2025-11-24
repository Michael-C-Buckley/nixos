{
  flake.modules.homeManager.alpine = {
    programs = {
      direnv = {
        enable = true;
      };
    };
  };
}
