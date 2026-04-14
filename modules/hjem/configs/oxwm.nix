{
  config,
  lib,
  ...
}: let
  inherit (config.flake) userModules;
in {
  # Intake my user modules directory for OXWM and reproduce it
  flake.custom.hjemConfigs.oxwm = {config, ...}: {
    hjem.users.${config.custom.hjem.username} = {
      xdg.config.files =
        builtins.mapAttrs
        (_: value: {
          source = value;
          type = "copy";
          permissions = "0644";
        })
        (lib.mapAttrs'
          (name: value: {
            name = "oxwm/${name}.lua";
            inherit value;
          })
          userModules.oxwm);
    };
  };
}
