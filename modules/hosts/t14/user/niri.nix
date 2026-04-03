{config, ...}: {
  flake.modules.nixos.t14 = {
    custom.niri.extraConfig = config.flake.custom.extraConfigs.t14-niri;
  };
}
