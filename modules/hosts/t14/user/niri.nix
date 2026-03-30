{config, ...}: {
  flake.modules.nixos.t14 = {
    custom.niri.extraConfig = config.flake.extraConfigs.t14-niri;
  };
}
