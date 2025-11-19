# My laptop has the most wifi since I have a handful of profiles declared
let
  # These functions just make the logic below way more organized by moving them out
  # The basic wifi setup is quite plain, just setup the boilerplate with this function
  mkWifi = {
    name,
    ssid,
    psk,
  }: {
    connection = {
      id = name;
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

  # Name-value pair for use with listToAttrs
  nameWifi = name: {
    inherit name;
    value = mkWifi {
      inherit name;
      ssid = "\$${name}_SSID";
      psk = "\$${name}_PSK";
    };
  };

  mkIpv4Info = octet: {
    address = "172.${octet}.248.14/16";
    # Statics to get around routing issues from VRRP
    route2 = "192.168.48.0/20,172.${octet}.248.30,50";
    route3 = "192.168.61.1/32,172.${octet}.248.31";
    route4 = "192.168.61.2/32,172.${octet}.248.32";
    route5 = "192.168.61.3/32,172.${octet}.248.33";
    route6 = "192.168.63.10/32,172.${octet}.248.10";
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

        profiles =
          builtins.listToAttrs (map nameWifi ["SHAWN" "R11" "R12" "R2"])
          // {
            # Additional static routes exist to connect to my home lab
            # The `/20` is the local prefix
            # The `/32` routes are the UFF cluster members with static loopback routes
            #  because VRRP otherwise interferes with routing to them directly
            home = {
              connection.interface-name = "wlp3s0";
              ipv4 = mkIpv4Info "16";
              ipv6.address = "fe80::a14/64";
            };

            home2 = {
              connection.interface-name = "wlp3s0";
              ipv4 = mkIpv4Info "30";
              ipv6.address = "fe80::a14/64";
            };
          };
      };
    };
  }
