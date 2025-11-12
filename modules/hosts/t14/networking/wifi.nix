let
  mkWifi = {
    ssid,
    psk,
  }: {
    connection = {
      id = "T14-Home-Wifi";
      type = "wifi";
      interface-name = "wlp3s0";
    };
    wifi = {
      inherit ssid;
      mode = "infrastructure";
    };
    wifi-security = {
      inherit psk;
      key-mgmt = "wpa-psk";
    };
    ipv4.method = "auto";
    ipv6.method = "auto";
  };
in
  {config, ...}: let
    inherit (config) flake;
  in {
    flake.modules.nixos.t14 = {config, ...}: {
      imports = [flake.modules.nixos.home-wifi];
      networking.networkmanager.ensureProfiles = {
        environmentFiles = with config.sops.secrets; [
          shawn-wifi.path
          r1-wifi.path
          r2-wifi.path
        ];

        profiles = {
          home = {
            connection.interface-name = "wlp3s0";
            ipv4 = {
              address = "172.16.248.14/16";
              route2 = "192.168.48.0/20,172.16.248.30,50";
            };
            ipv6.address = "fe80::a14/64";
          };

          home2 = {
            connection.interface-name = "wlp3s0";
            ipv4 = {
              address = "172.30.248.14/16";
              route2 = "192.168.48.0/20,172.30.248.30,50";
            };
            ipv6.address = "fe80::a14/64";
          };
          shawn = mkWifi {
            ssid = "$SHAWN_SSID";
            psk = "$SHAWN_PSK";
          };
          r11 = mkWifi {
            ssid = "$R11_SSID";
            psk = "$R11_PSK";
          };
          r12 = mkWifi {
            ssid = "$R12_SSID";
            psk = "$R12_PSK";
          };
          r2 = mkWifi {
            ssid = "$R2_SSID";
            psk = "$R2_PSK";
          };
        };
      };
    };
  }
