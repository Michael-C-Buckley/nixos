{config, ...}: {
  flake.modules.nixos.uff = {
    imports = with config.flake.modules.nixos; [
      lab-network
      vrrp
    ];

    networking = {
      interfaces = {
        eno1.mtu = 1500;
        enu2.mtu = 9000;
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
