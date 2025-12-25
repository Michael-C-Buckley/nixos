{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.uff = {config, ...}: let
    inherit (config.networking) hostName;
    lo = flake.lib.network.getAddress flake.hosts.${hostName}.interfaces.lo.ipv4;
  in {
    imports = with flake.modules.nixos; [
      lab-network
      vrrp
    ];

    services.dnscrypt-proxy.settings.listen_addresses = [
      "192.168.61.0:53"
      "${lo}:53"
      "127.0.0.153:53"
    ];

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
