{
  config,
  configPaths,
  lib,
  pkgs,
  ...
}:
{
  packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.localGram ];
  xdg.config.files."gram/themes/oasis_midnight_dark.json".source =
    configPaths.gram + "/themes/oasis_midnight_dark.json";
  activation.commands."30-gram-settings" = ''
    target=${lib.escapeShellArg "${config.xdg.config.directory}/gram/settings.jsonc"}
    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
      ${pkgs.coreutils}/bin/install -Dm600 ${configPaths.gram + "/settings.jsonc"} "$target"
    fi
  '';
}
