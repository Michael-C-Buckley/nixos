{config, ...}: let
  inherit (config.flake.hosts.p520) interfaces;
in {
  flake.modules.nixos.p520 = {
    networking = {
      # TODO: switch to using internal DNS server once set up
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];

      hostName = "p520";
      hostId = "181a3ead";

      interfaces = {
        br0.ipv4.addresses = [
          {
            address = interfaces.br0.ipv4;
            prefixLength = 27;
          }
        ];
      };
    };
  };
}
