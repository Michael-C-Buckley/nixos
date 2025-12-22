{config, ...}: let
  inherit (config.flake.hosts.x570) interfaces;

  # De-duplicate link spam
  mkLink = address: prefixLength: [
    {
      inherit address prefixLength;
    }
  ];

  mkLanLink = address: prefixLength: {
    mtu = 9000;
    ipv4.addresses = mkLink address prefixLength;
  };
in {
  flake.modules.nixos.x570 = {
    systemd.network = {
      # Don't wait for DHCP as I use static IPs
      wait-online.anyInterface = true;
    };

    networking = {
      hostId = "c07fa570";
      hostName = "x570";

      defaultGateway = {
        address = "192.168.48.30";
        interface = "eno1";
        metric = 20;
      };

      interfaces = {
        eno1 = mkLanLink interfaces.eno1.ipv4 24;
        eno2 = mkLanLink interfaces.eno2.ipv4 28;
        enx3 = mkLanLink interfaces.enx3.ipv4 28;
        lo.ipv4.addresses = mkLink interfaces.lo.ipv4 32;
      };
    };
  };
}
