{
  network = {
    version = 2;
    renderer = "networkd";
    ethernets = {
      eno1 = {
        match.macaddress = "9c:6b:00:c0:ac:92";
        set-name = "eno1";
        dhcp4 = false;
      };
      enp2 = {
        match.macaddress = "c0:a1:c3:a4:13:d0";
        set-name = "enp2";
        addresses = [ "192.168.60.133/28" ];
      };
      enx3 = {
        match.macaddress = "90:e2:ba:5f:f3:68";
        set-name = "enx3";
        addresses = [ "192.168.60.147/28" ];
      };
      enx4 = {
        match.macaddress = "90:e2:ba:5f:f3:69";
        set-name = "enx4";
        addresses = [ "192.168.60.3/29" ];
      };
      wlo1 = {
        match.macaddress = "28:16:ad:4b:1a:31";
        set-name = "wlo1";
        dhcp4 = true;
        dhcp6 = true;
        accept-ra = true;
      };
      lo.addresses = [
        "127.0.0.1/8"
        "::1/128"
        "192.168.63.6/32"
      ];
    };
    bridges = {
      br0 = {
        interfaces = [ ];
        addresses = [ "192.168.56.33/27" ];
      };
      br1 = {
        interfaces = [ "eno1" ];
        addresses = [ "192.168.59.9/27" ];
        routes = [
          {
            to = "default";
            via = "192.168.59.1";
            metric = 49;
          }
        ];
      };
      br100 = {
        interfaces = [ ];
        addresses = [ "192.168.56.38/27" ];
      };
    };
  };
}
