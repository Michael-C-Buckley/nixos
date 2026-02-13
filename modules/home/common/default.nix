{config, ...}: {
  flake.modules.homeManager.default = {
    imports = with config.flake.modules.homeManager; [
      programs
      packages
    ];

    home = {
      username = "michael";
      homeDirectory = "/home/michael";
    };

    programs.home-manager.enable = true;
  };
}
