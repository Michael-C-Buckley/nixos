{
  flake.modules.uff.networking = {lib, ...}: let
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
      enusb1 = {
        mac = mkOption {
          type = str;
          description = "USB 2.5G Ethernet MAC address.";
        };
        addresses = mkAddrs "USB 2.5G Ethernet";
      };
    };
  };
}
