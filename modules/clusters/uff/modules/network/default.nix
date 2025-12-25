{config, ...}: {
  flake.modules.nixos.uff = {
    imports = with config.flake.modules.nixos; [
      lab-network
      vrrp
    ];

    services.dnscrypt-proxy.settings.listen_addresses = ["0.0.0.0:53" "[::]:53"];

    networking = {
      interfaces = {
        lo.ipv4.addresses = [
          {
            #Cluster anycast gateway, individual loopbacks defined in lab-network
            address = "192.168.61.0";
            prefixLength = 32;
          }
        ];
      };
      firewall = {
        allowedTCPPorts = [53];
        allowedUDPPorts = [53];
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
