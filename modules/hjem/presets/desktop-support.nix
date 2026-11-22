{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.environment) sessionVariables;
  dconfFile = pkgs.writeText "hjem-dconf.ini" (
    lib.generators.toINI
      {
        mkKeyValue = key: value: "${key}=${toString (lib.gvariant.mkValue value)}";
      }
      {
        "org/gnome/desktop/interface" = {
          cursor-theme = sessionVariables.XCURSOR_THEME or "Adwaita";
          cursor-size = lib.gvariant.mkInt32 (lib.toInt (sessionVariables.XCURSOR_SIZE or "24"));
        };
      }
  );
in
{
  _file = __curPos.file;
  key = __curPos.file;
  assertions = [
    {
      assertion = pkgs.stdenv.hostPlatform.isLinux;
      message = "Desktop home modules require Linux.";
    }
  ];
  xdg.data.files = lib.mkIf (config.xdg.mime-apps.default-applications != { }) {
    "applications/mimeapps.list".source = config.xdg.config.files."mimeapps.list".source;
  };
  systemd.targets.tray = lib.mkIf config.environment.useSystemd {
    description = "System tray";
    requires = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
  };
  activation.commands."50-dconf" = ''
    if [ -n "''${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
      ${pkgs.dconf}/bin/dconf load / < ${dconfFile}
    else
      ${pkgs.dbus}/bin/dbus-run-session -- ${pkgs.dconf}/bin/dconf load / < ${dconfFile}
    fi
  '';
}
