{
  self,
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) attrValues mkOverride;
in {
  imports = [
    inputs.hjem.nixosModules.default
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
    extraModules = attrValues self.userModules ++ [inputs.hjem-rum.hjemModules.default];

    #linker = inputs'.hjem.packages.smfh;

    users.root = {
      enable = true;
      user = "root";
      directory = "/root";
    };
  };
}
