{
  flake.modules.nixos.uff = {lib, ...}: {
    # Try my local cache first
    nix.settings.substituters = lib.mkBefore [
      "http://192.168.48.5:5000"
    ];
  };
}
