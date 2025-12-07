{config, ...}: let
  inherit (config.flake) hosts;
in {
  flake.modules.nixos.uff = {config, ...}: let
    inherit (hosts.${config.networking.hostName}.interfaces) lo eno1 enu2;
  in {
    networking.interfaces = {
      enu2 = {
        mtu = 9000;
        ipv4.addresses = [
          {
            address = enu2.ipv4;
            prefixLength = 28;
          }
        ];
      };
      eno1.ipv4.addresses = [
        {
          address = eno1.ipv4;
          prefixLength = 24;
        }
      ];
      lo.ipv4.addresses = [
        {
          address = lo.ipv4;
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
