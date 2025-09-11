# An attempting at solving cursor issues
# Built off of: https://gitlab.com/fazzi/nixohess/-/blob/main/modules/programs/hyprland/cursor.nix?ref_type=heads
{
  lib,
  pkgs,
  ...
}: {
  environment.sessionVariables = {
    HYPRCURSOR_THEME = "Nordzy-hyprcursors-white";
    HYPRCURSOR_SIZE = 24;
    XCURSOR_THEME = "Nordzy-cursors-white";
    XCURSOR_SIZE = 24;
    # as a list makes this append to instead of overwrite.
    XCURSOR_PATH = ["${pkgs.nordzy-cursor-theme}/share/icons"];
  };

  hjem.users.michael = {
    packages = [pkgs.nordzy-cursor-theme];
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
}
