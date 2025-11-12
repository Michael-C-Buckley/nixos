# I share the basic home network among multiple hosts, this is the blanket common components of it
# Individual needs like addresses settings are done per-host
{
  flake.modules.nixos.home-wifi = {config, ...}: {
    networking.networkmanager.ensureProfiles = {
      environmentFiles = [config.sops.secrets.michael-wifi.path];

      profiles = {
        home = {
          connection = {
            id = "Home-Wifi";
            type = "wifi";
            autoconnect-priority = 10;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$MICHAEL_SSID";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$MICHAEL_PSK";
          };
          ipv4 = {
            method = "manual";
            ignore-auto-dns = true;
            ignore-auto-routes = true;
            route1 = "0.0.0.0/0,172.16.1.1,50";
          };
          ipv6 = {
            method = "manual";
            ignore-auto-dns = true;
            ignore-auto-routes = true;
          };
        };
        home2 = {
          connection = {
            id = "Home-Wifi2";
            type = "wifi";
            autoconnect-priority = 5;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$MICHAEL_SSID2";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$MICHAEL_PSK2";
          };
          ipv4 = {
            method = "manual";
            ignore-auto-dns = true;
            ignore-auto-routes = true;
            route1 = "0.0.0.0/0,172.30.1.1,50";
          };
          ipv6 = {
            method = "manual";
            ignore-auto-dns = true;
            ignore-auto-routes = true;
          };
        };
      };
    };
  };
}
