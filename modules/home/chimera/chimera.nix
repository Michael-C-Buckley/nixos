{config, ...}: {
  flake.modules.homeManager.chimera = {pkgs, ...}: {
    imports = with config.flake.modules.homeManager; [
      default
      helium
      chimera-ssh-agent
      chimera-zed-deploy
    ];
    home = {
      packages = with pkgs; [blueman];
      stateVersion = "25.11";
    };
  };
}
