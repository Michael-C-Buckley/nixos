# Basic local development-based tools
{config, ...}: {
  flake.modules.nixos.packages-development = {pkgs, ...}: let
    inherit (config.flake) lib packageLists;
  in {
    environment.systemPackages = lib.packageLists.makePkgList pkgs packageLists.development;
  };
}
