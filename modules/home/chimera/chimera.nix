{config, ...}: {
  flake.modules.homeManager.chimera = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    imports = with config.flake.modules.homeManager; [
      default
      helium
      chimera-ssh-agent
      chimera-zed-deploy
    ];
    home = {
      packages = builtins.attrValues {
        inherit (pkgs) blueman;
        inherit (config.flake.packages.${system}) niri-t14;
      };
      stateVersion = "25.11";
    };
  };
}
