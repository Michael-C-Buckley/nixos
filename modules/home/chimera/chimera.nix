{config, ...}: {
  flake.modules.homeManager.chimera = {
    imports = with config.flake.modules.homeManager; [
      default
      helium
      chimera-ssh-agent
      chimera-zed-deploy
    ];
    home.stateVersion = "25.11";
  };
}
