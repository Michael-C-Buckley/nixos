{lib, ...}: {
  options = {
    networking.hardware = {
      enusb1.mac = lib.mkOption {
        type = lib.types.str;
        description = "The MAC address of the 2.5G USB NIC.";
      };
    };
    custom.uff = {
      loopbackIPv4 = lib.mkOption {
        type = lib.types.str;
        description = "The default IP of the loopback on the built-in ethernet.";
      };
      ethIPv4 = lib.mkOption {
        type = lib.types.str;
        description = "The default IP of the built-in ethernet.";
      };

      enusb1 = {
        ipv4 = {
          addr = lib.mkOption {
            type = lib.types.str;
            description = "The IPv4 address of the 2.5G USB NIC.";
          };
          prefixLength = lib.mkOption {
            type = lib.types.int;
            default = 24;
            description = "The IPv4 CIDR mask to use with 2.5G USB NIC.";
          };
        };
      };
    };
  };
}
