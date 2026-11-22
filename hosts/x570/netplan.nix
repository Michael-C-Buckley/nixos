{
  network = {
    version = 2;
    renderer = "networkd";
    ethernets = {
      eno1 = {
        match.macaddress = "18:c0:4d:89:83:97";
        set-name = "eno1";
        dhcp4 = false;
      };
      eno2 = {
        match.macaddress = "18:c0:4d:89:83:98";
        set-name = "eno2";
        dhcp4 = true;
        dhcp6 = true;
        accept-ra = true;
      };
      enx3 = {
        match.macaddress = "10:70:fd:f0:f0:3c";
        set-name = "enx3";
        dhcp4 = true;
        dhcp6 = true;
        accept-ra = true;
      };
      enx4 = {
        match.macaddress = "10:70:fd:f0:f0:3d";
        set-name = "enx4";
        dhcp4 = true;
        dhcp6 = true;
        accept-ra = true;
      };
      # Preserve networkd's DHCP fallback for a connected Wi-Fi link.
      wifi = {
        match.name = "wl*";
        dhcp4 = true;
        dhcp6 = true;
        accept-ra = true;
        dhcp4-overrides.route-metric = 1025;
        dhcp6-overrides.route-metric = 1025;
      };
    };
    bridges = {
      br1 = {
        interfaces = [ "eno1" ];
        addresses = [ "192.168.59.7/27" ];
        routes = [
          {
            to = "default";
            via = "192.168.59.1";
            metric = 99;
          }
        ];
      };
      br100.interfaces = [ ];
    };
  };
}
