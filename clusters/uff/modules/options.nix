{lib, ...}: {
  options.custom.uff = {
    loopbackIPv4 = lib.mkOption {
      type = lib.types.str;
      description = "The default IP of the bridge on the built-in ethernet.";
    };
    bridgeIPv4 = lib.mkOption {
      type = lib.types.str;
      description = "The default IP of the bridge on the built-in ethernet.";
    };

    enusb1 = {
      macAddr = lib.mkOption {
        type = lib.types.str;
        description = "The MAC address of the 2.5G USB NIC.";
      };
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
}