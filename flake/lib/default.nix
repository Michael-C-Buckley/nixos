{lib, ...}: {
  flake.lib = {
    ips = import ./ips.nix {inherit lib;};
    wireguard = import ./wireguard.nix {inherit lib;};
  };
}
