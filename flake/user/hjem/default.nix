# Split into per-host basis
{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit
    (config.hjem.users.michael)
    fileList
    packageList
    ;

  inherit (lib) mkDefault;

  myPkgs = import ../packageSets/common.nix {inherit self pkgs;};
in {
  imports = [../options.nix];

  programs.fish.enable = mkDefault true;

  users.users.michael = {
    packages = myPkgs ++ packageList;
    shell = pkgs.fish;
  };

  hjem = {
    extraModules = [
      ./modules/hjemOptions.nix
      ./modules/gpg.nix
    ];
    users.michael = {
      enable = true;
      user = "michael";
      directory = "/home/michael";

      # Push the existing files in to be merged
      files = (import ../findFiles.nix {inherit lib;}) // fileList;

      gnupg = {
        enable = true;
        enableSSHsupport = true;
      };
    };
  };
}
