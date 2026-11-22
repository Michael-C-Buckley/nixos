{
  config,
  lib,
  pkgs,
  ...
}:
let
  gtkSettings = {
    gtk-cursor-theme-name = config.environment.sessionVariables.XCURSOR_THEME or "Adwaita";
    gtk-cursor-theme-size = config.environment.sessionVariables.XCURSOR_SIZE or "24";
  };
  format = pkgs.formats.ini { };
in
{
  _file = __curPos.file;
  key = __curPos.file;
  packages = [ pkgs.adw-gtk3 ];
  environment.sessionVariables.GTK2_RC_FILES = "${config.directory}/.gtkrc-2.0";
  files.".gtkrc-2.0".text = ''
    gtk-cursor-theme-name="${gtkSettings.gtk-cursor-theme-name}"
    gtk-cursor-theme-size=${gtkSettings.gtk-cursor-theme-size}
  '';
  xdg.config.files = lib.genAttrs [ "gtk-3.0/settings.ini" "gtk-4.0/settings.ini" ] (_: {
    source = format.generate "gtk-settings.ini" { Settings = gtkSettings; };
  });
}
