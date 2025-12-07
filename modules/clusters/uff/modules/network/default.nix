{config, ...}: {
  flake.modules.nixos.uff = {
    imports = with config.flake.modules.nixos; [
      bfd
      bgp
      ospf
      vrrp
    ];

    networking = {
      interfaces.enusb1.mtu = 9000;
      useDHCP = false;
      useNetworkd = true;
      networkmanager = {
        enable = true;
        unmanaged = ["eno1" "enu2" "br100"];
        ensureProfiles.profiles = {
          home.connection.interface-name = "wlan1";
          home2.connection.interface-name = "wlan1";
        };
      };
    };

    services = {
      ntpd-rs.enable = true;
      iperf3 = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
