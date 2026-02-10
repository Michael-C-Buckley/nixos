{config, ...}: {
  flake.modules.nixos.packages-network = {functions, ...}: let
    inherit (config.flake.packageLists) network;
    inherit (functions.packageLists) makePkgList;
  in {
    environment.systemPackages = makePkgList network;
  };
}
