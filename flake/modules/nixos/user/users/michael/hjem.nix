# Split into per-host basis
{
  config,
  pkgs,
  lib,
  self',
  ...
}: let
  inherit (config) packageSets;
  inherit (config.features.michael) minimalGraphical extendedGraphical;
  inherit (lib) mkIf mkDefault optionals mkOverride;
  local = config.hjem.users.michael;
  inherit (local) fileList;

  useImperm = config.system.impermanence.enable && local.system.impermanence.enable;
  extGfx = mkDefault extendedGraphical;

  nvfVer =
    if extendedGraphical
    then ""
    else "-minimal";

  userPkgs =
    packageSets.common
    ++ optionals minimalGraphical packageSets.minimalGraphical
    ++ optionals extendedGraphical packageSets.extendedGraphical;
in {
  imports = [
    ./programs/hyprland
    ./vscode.nix
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
    files = import ./files/fileList.nix {inherit config lib fileList;};

    environment.gnupg = {
      enable = true;
      enableSSHsupport = true;
    };

    programs = {
      custom.ns.enable = extGfx;
      librewolf.enable = extGfx;
      signal.enable = extGfx;
      discord.enable = extGfx;
      telegram.enable = extGfx;
      nvf = {
        enable = true;
        package = self'.packages."nvf${nvfVer}";
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
      gtk = {
        manage = extGfx;
        theme.name = "Materia-dark";
        theme.package = pkgs.materia-theme;
        iconTheme.name = "Gruvbox Dark";
        iconTheme.package = pkgs.gruvbox-dark-icons-gtk;
      };
    };
  };
}
