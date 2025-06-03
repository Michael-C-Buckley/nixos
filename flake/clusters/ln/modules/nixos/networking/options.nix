{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;

  mkAddrOption = desc:
    mkOption {
      type = listOf str;
      default = null;
      description = desc;
    };

  mkAddrs = intDesc: {
    ipv4 = mkAddrOption "${intDesc} IPv4 address list (with CIDRs).";
    ipv6 = mkAddrOption "${intDesc} IPv6 address list (with CIDRs).";
  };
in {
  options.networkd = {
    eno1.addresses = mkAddrs "Onboard Ethernet";
    enmlx1 = {
      mac = mkOption {
        type = str;
        description = "Mellanox CX-3 Port 1 Ethernet MAC address.";
      };
      addresses = mkAddrs "Mellanox CX-3 Port 1 Ethernet";
    };
    enmlx2 = {
      mac = mkOption {
        type = str;
        description = "Mellanox CX-3 Port 2 Ethernet MAC address.";
      };
      addresses = mkAddrs "Mellanox CX-3 Port 2 Ethernet";
    };
  };
}
