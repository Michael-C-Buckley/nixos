{
  flake.modules.nixos.uff = {
    networking = {
      interfaces.enusb1.mtu = 9000;
      useDHCP = false;
      useNetworkd = true;
      networkmanager = {
        enable = true;
        unmanaged = ["eno1" "enusb1" "br100"];
        ensureProfiles.profiles = {
          home.connection.interface-name = "wlp2s0";
          home2.connection.interface-name = "wlp2s0";
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
