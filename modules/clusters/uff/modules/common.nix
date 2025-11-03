{config, ...}: {
  flake.modules.nixos.uff = {lib, ...}: {
    imports = [
      config.flake.modules.nixos.wifi
    ];

    # Try my local cache first
    nix.settings.substituters = lib.mkBefore [
      "http://192.168.48.5:5000"
    ];
  };
}
