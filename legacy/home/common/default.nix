{
  flake.modules.homeManager.default = {
    home = {
      username = "michael";
      homeDirectory = "/home/michael";
    };

    programs.home-manager.enable = true;
  };
}
