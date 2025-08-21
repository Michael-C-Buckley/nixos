# Split into per-host basis
{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) packageSets;
  inherit (config.features.michael) minimalGraphical extendedGraphical;
  inherit (lib) mkDefault optionals mkOverride;
  local = config.hjem.users.michael;

  extGfx = mkDefault extendedGraphical;

  myCommonPkgs = import ./packageSets/common.nix {inherit pkgs;};
  myGUIExtPkgs = import ./packageSets/extendedGraphical.nix {inherit pkgs;};

  userPkgs =
    packageSets.common
    ++ myCommonPkgs
    ++ optionals minimalGraphical packageSets.minimalGraphical
    ++ optionals extendedGraphical packageSets.extendedGraphical
    ++ optionals extendedGraphical myGUIExtPkgs;
in {
  # Home is not impermanent, but this removes these from snapshots
  environment.persistence."/cache".users.michael.directories =
    [
      "Downloads"
      ".cache"
    ]
    ++ optionals extendedGraphical [
      ".config/legcord/Cache"
    ];

  users.users = {
    michael = {
      packages = userPkgs ++ local.packageList;
      shell = mkOverride 900 pkgs.fish;
    };
  };

  hjem.users.michael = {
    enable = true;
    user = "michael";
    directory = "/home/michael";

    # Push the existing files in to be merged, for now
    files = self.outputs.userConfigurations.michael {inherit lib;} // local.fileList;

    environment.gnupg = {
      enable = true;
      enableSSHsupport = true;
    };

    programs = {
      # keep-sorted start
      custom.ns.enable = extGfx;
      nvf.enable = extGfx;
      vscode.enable = extGfx;
      # keep-sorted end
    };

    rum.misc.gtk = {
      enable = extGfx;
      packages = with pkgs; [
        nordzy-cursor-theme
        gruvbox-dark-icons-gtk
        arc-theme
      ];
      settings = {
        theme-name = "Arc-Dark";
        application-prefer-dark-theme = true;
      };
    };

    appearance = {
      cursor = {
        manage = extGfx;
        hyprtheme = "Nordzy-hyprcursors-white";
        xtheme = "Nordzy-cursors-white";
        size = 28;
        package = pkgs.nordzy-cursor-theme;
      };
    };
  };
}
