# Base Entry for the Hjem outputs
{
  self,
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOverride;
in {
  imports = [
    inputs.hjem.nixosModules.default
    self.nixosModules.packageSets
    ./options/hjem.nix
    ./users/michael/hjem.nix
  ];

  users.users = {
    root = {
      packages = config.packageSets.common;
      shell = mkOverride 900 pkgs.fish;
    };
  };

  hjem = {
    clobberByDefault = true;
    extraModules = [
      self.userModules.default
    ];

    users.root = {
      enable = true;
      user = "root";
      directory = "/root";
    };
  };
}
