# An attempting at solving cursor issues
# Built off of: https://gitlab.com/fazzi/nixohess/-/blob/main/modules/programs/hyprland/cursor.nix?ref_type=heads
{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.cursor = {
    pkgs,
    lib,
    ...
  }: let
    cursor = flake.packages.${pkgs.stdenv.hostPlatform.system}.nordzy-cursor;
  in {
    environment.sessionVariables = {
      HYPRCURSOR_THEME = "Nordzy-hyprcursors-white";
      HYPRCURSOR_SIZE = 24;
      XCURSOR_THEME = "Nordzy-cursors-white";
      XCURSOR_SIZE = 24;
      # as a list makes this append to instead of overwrite.
      XCURSOR_PATH = ["${cursor}/share/icons"];
    };

    hjem.users.michael = {
      packages = [cursor];
      xdg.data.files."icons/default/index.theme" = {
        generator = lib.generators.toINI {};
        value = {"Icon Theme".Inherits = "Nordzy-cursors-white";};
      };
    };
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = "Nordzy-cursors-white";
            cursor-size = lib.gvariant.mkInt32 24;
          };
        };
      }
    ];
  };
}
