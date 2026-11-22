{
  config,
  pkgs,
  ...
}:
let
  format = pkgs.formats.ini { };
  plugins = "${config.environment.profileDirectory}/${pkgs.qt5.qtbase.qtPluginPrefix}:${config.environment.profileDirectory}/${pkgs.qt6.qtbase.qtPluginPrefix}";
  qml = "${config.environment.profileDirectory}/${pkgs.qt5.qtbase.qtQmlPrefix}:${config.environment.profileDirectory}/${pkgs.qt6.qtbase.qtQmlPrefix}";
in
{
  _file = __curPos.file;
  key = __curPos.file;
  packages = [
    pkgs.qt6Packages.qt6ct
    pkgs.libsForQt5.qt5ct
  ];
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_PLUGIN_PATH = plugins;
    QML2_IMPORT_PATH = qml;
  };
  xdg.config.files = builtins.listToAttrs (
    map
      (name: {
        name = "${name}/${name}.conf";
        value.source = format.generate "${name}.conf" {
          Appearance = {
            style = "Fusion";
            custom_palette = true;
            color_scheme_path = "${config.xdg.config.directory}/${name}/colors/noctalia.conf";
          };
        };
      })
      [
        "qt5ct"
        "qt6ct"
      ]
  );
}
