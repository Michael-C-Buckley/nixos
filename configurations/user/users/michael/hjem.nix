# Split into per-host basis
{
  config,
  pkgs,
  system,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  local = config.hjem.users.michael;
  useImperm = config.system.impermanence.enable && local.system.impermanence.enable;
  extGfx = mkDefault config.features.michael.extendedGraphical;
in {
  imports = [
    ./vscode.nix
  ];

  environment.persistence = lib.mkIf useImperm {
    "/cache".users.michael.directories = local.system.impermanence.userCacheDirs;
    "/persist".users.michael.directories = local.system.impermanence.userPersistDirs;
  };

  hjem.users.michael = {
    apps = {
      browsers.librewolf.enable = extGfx;
      communication = {
        signal.enable = extGfx;
        discord.enable = extGfx;
        telegram.enable = extGfx;
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
