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
  inherit (lib) mkOverride;
  commonPackages = import ./packages/common.nix {inherit self config pkgs inputs system;};
in {
  imports = [
    inputs.hjem.nixosModules.default
    ./options
    ./modules/vscode/hjem.nix
    ./michael.nix
    ./default.nix
  ];

  users.users = {
    michael = {
      packages = import ./packages/userPkgs.nix {inherit config inputs pkgs lib commonPackages;};
      shell = mkOverride 900 pkgs.fish;
    };
    root = {
      packages = commonPackages;
      shell = mkOverride 900 pkgs.fish;
    };
  };

  hjem = {
    clobberByDefault = true;
    users.michael = {
      enable = true;
      user = "michael";
      directory = "/home/michael";
      files = lib.mkMerge [
        (import ./files/fileList.nix {inherit config lib;})
        config.home.features.michael.fileList
      ];
    };
    # Here's an attempt at seeing if Hjem can apply user configs to root
    users.root = {
      enable = true;
      user = "root";
      directory = "/root";
      files = import ./files/fileList.nix {inherit config lib;};
    };
  };
}
