{config, ...}: {
  flake.modules.nixos.packages-network = {pkgs, ...}: let
    inherit (config.flake) lib packageLists;
  in {
    environment.systemPackages = lib.packageLists.makePkgList pkgs packageLists.network;
  };
}
