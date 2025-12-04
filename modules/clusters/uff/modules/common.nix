{config, ...}: {
  flake.modules.nixos.uff = {
    imports = with config.flake.modules.nixos; [
      netbird
      wifi
      wifi-home
    ];

    nix.settings.substituters = [
      "http://p520:5000"
    ];
  };
}
