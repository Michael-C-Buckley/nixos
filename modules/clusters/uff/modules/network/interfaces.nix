{
  flake.modules.nixos.uff = {config, ...}: {
    networking.interfaces = {
      enusb1.mtu = 9000;
      lo.ipv4.addresses = [
        {
          address = config.networking.loopback.ipv4;
          prefixLength = 32;
        }
        {
          address = "192.168.61.0";
          prefixLength = 32;
        }
      ];
    };
  };
}
