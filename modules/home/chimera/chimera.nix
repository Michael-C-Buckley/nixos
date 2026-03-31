{config, ...}: {
  flake.modules.homeManager.chimera = {
    imports = with config.flake.modules.homeManager; [
      default
      helium
      chimera-ssh-agent
    ];
    home.stateVersion = "25.11";
  };
}
