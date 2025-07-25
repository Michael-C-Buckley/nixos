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

  userPkgs =
    packageSets.common
    ++ optionals minimalGraphical packageSets.minimalGraphical
    ++ optionals extendedGraphical packageSets.extendedGraphical;

  # WIP: Integrat this better
  myPackages = with pkgs; [
    alejandra
  ];
in {
  # Home is not impermanent, but this removes these from snapshots
  environment.persistence."/cache".users.michael.directories = [
    "Downloads"
    ".cache/nix" # Git caches are very large
  ];

  users.users = {
    michael = {
      packages = userPkgs ++ local.packageList ++ myPackages;
      shell = mkOverride 900 pkgs.fish;
    };
  };

  hjem.users.michael = {
    enable = true;
    user = "michael";
    directory = "/home/michael";

    # WIP: Remove this entire feature
    system.impermanence.enable = false;

    # Push the existing files in to be merged, for now
    files = import "${self}/flake/configurations/user/michael" {inherit lib;} // local.fileList;

    environment.gnupg = {
      enable = true;
      enableSSHsupport = true;
    };

    programs = {
      # keep-sorted start
      custom.ns.enable = extGfx;
      discord.enable = extGfx;
      librewolf.enable = extGfx;
      nvf.enable = extGfx;
      signal.enable = extGfx;
      telegram.enable = extGfx;
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
