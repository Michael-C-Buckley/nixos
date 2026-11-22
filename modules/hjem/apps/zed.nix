{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.config.files."zed/themes/oasis_midnight_dark.json".source =
    ../../../configs/zed/themes/oasis_midnight_dark.json;
  activation.commands."30-zed-settings" = ''
    target=${lib.escapeShellArg "${config.xdg.config.directory}/zed/settings.json"}
    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
      ${pkgs.coreutils}/bin/install -Dm600 ${../../../configs/zed/settings.json} "$target"
    fi
  '';
}
