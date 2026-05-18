# Zed needs a writable config to operate normally
# I wish to just ensure a starting state so I'll be using Dinit
# to deploy the config if none exists
{
  config,
  lib,
  ...
}: let
  file = "/home/michael/.config/zed/settings.json";
in {
  flake.modules.homeManager.chimera-zed-deploy = {pkgs, ...}: let
    cfg = config.flake.custom.wrappers.mkZedConfig {inherit pkgs;};
    wrapper = pkgs.writeShellScriptBin "zed-deploy-wrapper" ''
      # Skip if the config already exists
      if [ -e ${file} ]; then
        exit 0
      else
        /usr/bin/mkdir /home/michael/.config/zed
        /usr/bin/cp ${cfg} ${file}
      fi
    '';
  in {
    xdg.configFile."dinit.d/zed-deploy".text = ''
      type = scripted
      command = ${lib.getExe wrapper}
    '';
  };
}
