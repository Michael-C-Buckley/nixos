{config, ...}: let
  hostName = "b550";
  inherit (config.flake.hosts.${hostName}.interfaces) lo br0;
in {
  flake.modules.nixos.${hostName} = {
    networking = {
      inherit hostName;
      hostId = "272a6fae";

      # TODO: switch to using internal DNS server once set up
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];

      interfaces = {
        lo.ipv4.addresses = [
          {
            address = lo.ipv4;
            prefixLength = 32;
          }
        ];
        br0.ipv4.addresses = [
          {
            address = br0.ipv4;
            prefixLength = 27;
          }
        ];
      };
    };
  };
}
