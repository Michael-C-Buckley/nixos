{config, ...}: {
  flake.modules.homeManager.default = {
    imports = with config.flake.modules.homeManager; [
      programs
      packages
      nvf
      helix
    ];

    home = {
      username = "michael";
      homeDirectory = "/home/michael";
    };

    programs.home-manager.enable = true;
  };
}
