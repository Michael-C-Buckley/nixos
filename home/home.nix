# Base Entry for Home-Manager
{config, lib, pkgs, ...}: let
  inherit (lib) mkDefault optionalAttrs;
  inherit (config.features.michael) useHome;
  commonPackages = (import ./packages/common.nix {inherit pkgs;});
in {
  imports = [
    ./options
    ./modules/vscode/home.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  programs.home-manager.enable = true;

  home = {
    username = "michael";
    homeDirectory = "/home/michael";
    stateVersion = mkDefault "24.05";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "librewolf";
      NIXOS_OZONE_WL = "1";
      GTK_USE_PORTAL = "1";
    };
  } // optionalAttrs useHome {
    file = import ./files/fileList.nix {inherit config lib;};
    packages = (import ./packages/userPkgs.nix {inherit config pkgs lib commonPackages;});
  };
}
