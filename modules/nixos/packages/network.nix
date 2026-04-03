{config, ...}: {
  flake.modules.nixos.packages-network = {functions, ...}: let
    inherit (config.flake.custom.packageLists) network;
    inherit (functions.packageLists) makePkgList;
  in {
    environment.systemPackages = makePkgList network;
  };
}
