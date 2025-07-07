# Base Entry for Home-Manager
# UNMAINTAINED: LIKELY NOT WORKING CURRENTLY
{lib, ...}: let
  inherit (lib) mkDefault;
  # commonPackages = import ./packages/common.nix {inherit self config pkgs inputs system;};
in {
  imports = [
    ../options
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  home = {
    username = "michael";
    homeDirectory = "/home/michael";
    stateVersion = mkDefault "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "librewolf";
      NIXOS_OZONE_WL = "1";
      GTK_USE_PORTAL = "1";
    };

    # file = import ./files/fileList.nix {inherit config lib;};
    # packages = import ./packages/userPkgs.nix {inherit config inputs pkgs lib commonPackages system;};
  };
}
