{
  config,
  lib,
  pkgs,
  ...
}:
let
  cursor = pkgs.callPackage ../../../packages/nordzy-cursor-white { };
  cursor_name = "Nordzy-cursors-white";
  cursor_size = 24;
  inherit (config.environment.sessionVariables) XCURSOR_THEME XCURSOR_SIZE;
  gtkSettings = ''
    [Settings]
    gtk-theme-name=adw-gtk3-dark
    gtk-icon-theme-name=Adwaita
    gtk-font-name=DejaVu Sans 11
    gtk-cursor-theme-name=${XCURSOR_THEME}
    gtk-cursor-theme-size=${XCURSOR_SIZE}
    gtk-application-prefer-dark-theme=true
  '';
in
{
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "breeze";
  };
  environment = {
    systemPackages = [
      pkgs.adw-gtk3
      pkgs.adwaita-icon-theme
      cursor
    ];
    etc = {
      "xdg/gtk-3.0/settings.ini".text = gtkSettings;
      "xdg/gtk-4.0/settings.ini".text = gtkSettings;
    };
  };
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          gtk-theme = "adw-gtk3-dark";
          icon-theme = "Adwaita";
          font-name = "DejaVu Sans 11";
          color-scheme = "prefer-dark";
          cursor-theme = cursor_name;
          cursor-size = lib.gvariant.mkInt32 cursor_size;
        };
      }
    ];
  };
  environment.sessionVariables = {
    XCURSOR_THEME = cursor_name;
    XCURSOR_SIZE = toString cursor_size;
    HYPRCURSOR_THEME = "Nordzy-hyprcursors-white";
    HYPRCURSOR_SIZE = toString cursor_size;
  };

  xdg.icons.fallbackCursorThemes = [ cursor_name ];
}
