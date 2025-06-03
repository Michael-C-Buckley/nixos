{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkDefault optionals;

  net = config.networking;

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  imports = [
    inputs.nix-secrets.nixosModules.network.hosts
    ./bgp.nix
    ./eigrp.nix
    ./options.nix
    ./ospf.nix
    ./vrrp.nix
    ./vxlan.nix
  ];

  # Set sane standards on file descriptor limits for FRR daemons
  services.frr = {
    bgpd.options = mkDefault ["--limit-fds 2048"];
    zebra.options = mkDefault ["--limit-fds 2048"];
    openFilesLimit = mkDefault 2048;
  };

  # Apply the loopback address if added
  networking.interfaces.lo.ipv4.addresses = optionals (net.loopback.ipv4 != null) [
    (addr net.loopback.ipv4 32)
  ];
}
