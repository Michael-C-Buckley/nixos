{config, ...}: let
  inherit (config.flake.hosts.x570) interfaces;

  # De-duplicate link spam
  mkLink = address: prefixLength: [
    {
      inherit address prefixLength;
    }
  ];
in {
  flake.modules.nixos.x570 = {
    systemd.network = {
      # Don't wait for DHCP as I use static IPs
      wait-online.anyInterface = true;
    };

    networking = {
      hostId = "c07fa570";
      hostName = "x570";
      interfaces = {
        lo.ipv4.addresses = mkLink interfaces.lo.ipv4 32;
      };
    };
  };
}
