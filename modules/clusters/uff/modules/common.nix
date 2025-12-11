{config, ...}: {
  flake.modules.nixos.uff = {
    imports = with config.flake.modules.nixos; [
      homelabPreset
      netbird
      wifi
      wifi-home
    ];
  };
}
