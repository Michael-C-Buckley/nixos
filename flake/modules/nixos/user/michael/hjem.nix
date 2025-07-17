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

  useImperm = config.system.impermanence.enable && local.system.impermanence.enable;
  extGfx = mkDefault extendedGraphical;

  userPkgs =
    packageSets.common
    ++ optionals minimalGraphical packageSets.minimalGraphical
    ++ optionals extendedGraphical packageSets.extendedGraphical;
in {
  imports = [
    ./impermanence.nix
  ];

  environment.persistence = lib.mkIf useImperm {
    "/cache".users.michael.directories = local.system.impermanence.userCacheDirs;
    "/persist".users.michael.directories = local.system.impermanence.userPersistDirs;
  };

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

    # Mirror the system's impermanence
    system.impermanence.enable = config.system.impermanence.enable;

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
