# Base Entry for Home-Manager
{
  self,
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: let
  inherit (lib) mkDefault optionalAttrs;
  inherit (config.features.michael) useHome;
  commonPackages = import ./packages/common.nix {inherit self config pkgs inputs system;};
in {
  imports = [
    ./options
    ./modules/vscode/home.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  home =
    {
      username = "michael";
      homeDirectory = "/home/michael";
      stateVersion = mkDefault "24.05";
      sessionVariables = {
        EDITOR = "nvim";
        BROWSER = "librewolf";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    }
    // optionalAttrs useHome {
      file = import ./files/fileList.nix {inherit config lib;};
      packages = import ./packages/userPkgs.nix {inherit config inputs pkgs lib commonPackages;};
    };
}
