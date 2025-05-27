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
    enx520p1 = {
      mac = mkOption {
        type = str;
        description = "Intel X520 Port 1 Ethernet MAC address.";
      };
      addresses = mkAddrs "ntel X520 Port 1 Ethernet";
    };
    enx520p2 = {
      mac = mkOption {
        type = str;
        description = "ntel X520 Port 2 Ethernet MAC address.";
      };
      addresses = mkAddrs "ntel X520 Port 2 Ethernet";
    };
  };
}
