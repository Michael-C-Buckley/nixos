# Base Entry for the Hjem outputs
{config, pkgs, lib, inputs, ...}: let
  inherit (lib) mkOverride;
  commonPackages = (import ./packages/common.nix {inherit pkgs;});
in {
  imports = [
    inputs.hjem.nixosModules.default
    ./options
    ./modules/vscode/hjem.nix
  ];

  users.users.michael.packages = (import ./packages/userPkgs.nix {inherit config pkgs lib commonPackages;});
  users.users.root.packages = commonPackages;

  # Add this above default but below force
  programs.fish.enable = true;
  users.users.michael.shell = mkOverride 900 pkgs.fish;

  hjem = {
    clobberByDefault = true;
    users.michael = {
      enable = true;
      user = "michael";
      directory = "/home/michael";
      files = import ./files/fileList.nix {inherit config lib;};
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
