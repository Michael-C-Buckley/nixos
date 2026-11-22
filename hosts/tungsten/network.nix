{
  imports = [ ../../modules/nixos/network/netplan ];

  services.resolved.enable = true;
  systemd.network.enable = true;

  networking = {
    useDHCP = false;
    dhcpcd.enable = false;
    networkmanager.enable = false;
    netplan.configurations."70-tungsten.yaml" = {
      network = {
        version = 2;
        renderer = "networkd";
        ethernets.eno1 = {
          match.macaddress = "52:54:00:6d:1f:b2";
          set-name = "eno1";
          dhcp4 = false;
          dhcp6 = false;
          accept-ra = false;
          addresses = [ "192.168.77.114/28" ];
          routes = [
            {
              to = "default";
              via = "192.168.77.113";
            }
          ];
          nameservers.addresses = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };
    };
  };
}
