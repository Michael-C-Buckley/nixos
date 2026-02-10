# Basic local development-based tools
{config, ...}: {
  flake.modules.nixos.packages-development = {functions, ...}: let
    inherit (functions.packageLists) makePkgList;
    inherit (config.flake.packageLists) development;
  in {
    environment.systemPackages = makePkgList development;
  };
}
