{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.uff = {config, ...}: {
    imports = with flake.modules.nixos; [
      lab-network
      vrrp
    ];

    networking = {
      interfaces = {
        eno1.mtu = 9000;
        enu2.mtu = 9000;
        lo.ipv4.addresses = [
          {
            address = flake.hosts.${config.networking.hostName}.interfaces.lo.ipv4;
            prefixLength = 32;
          }
          {
            address = "192.168.61.0";
            prefixLength = 32;
          }
        ];
      };
      useDHCP = false;
      networkmanager = {
        ensureProfiles.profiles = {
          home.connection.interface-name = "wlan1";
          home2.connection.interface-name = "wlan1";
        };
      };
    };
  };
}
