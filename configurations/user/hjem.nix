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
  rawUser = import ./packages/userPkgs.nix {inherit config self lib system;};

  # NVF selections
  extGfx = config.features.michael.extendedGraphical;
  nvfVersion =
    if extGfx
    then "default"
    else "minimal";
  nvf = [self.packages.${system}."nvf-${nvfVersion}"];
  commonPkgs = common ++ nvf;
  userPkgs = rawUser ++ nvf;
in {
  imports = [
    inputs.hjem.nixosModules.default
    self.nixosModules.packageSets
    ./options/hjem.nix
    ./users/michael/hjem.nix
  ];

  users.users = {
    michael = {
      packages = userPkgs ++ config.hjem.users.michael.packageList;
      shell = mkOverride 900 pkgs.fish;
    };
    root = {
      packages = commonPkgs;
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
        (import ./users/michael/files/fileList.nix {inherit config lib;})
      ];
      system.impermanence.enable = true;
    };

    users.root = {
      enable = true;
      user = "root";
      directory = "/root";
    };
  };
}
