# Base Entry for the Hjem outputs
{
  self,
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  inherit (config.packageSets) common;
  inherit (lib) mkOverride;
  userPackages = import ./packages/userPkgs.nix {inherit config self lib system;};
in {
  imports = [
    inputs.hjem.nixosModules.default
    self.nixosModules.packageSets
    ./options/hjem.nix
  ];

  users.users = {
    michael = {
      packages = userPackages;
      shell = mkOverride 900 pkgs.fish;
    };
    root = {
      packages = common;
      shell = mkOverride 900 pkgs.fish;
    };
  };

  hjem = {
    extraModules = [
      self.userModules.default
    ];

    clobberByDefault = true;
    users.michael = {
      enable = true;
      user = "michael";
      directory = "/home/michael";
      files = lib.mkMerge [
        (import ./files/fileList.nix {inherit config lib;})
      ];
    };
    
    users.root = {
      enable = true;
      user = "root";
      directory = "/root";
    };
  };
}
