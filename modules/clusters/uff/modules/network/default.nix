{
  flake.modules.nixos.uff-networking = {
    networking = {
      useNetworkd = true;
      networkmanager = {
        enable = true;
        unmanaged = ["eno1" "enusb1" "br100"];
      };
      useDHCP = false;
    };

    services = {
      ntpd-rs.enable = true;
      iperf3 = {
        enable = true;
        openFirewall = true;
      };
      # Allow local entities to use DNS
      unbound.settings.server = {
        access-control = [
          "127.0.0.0/8 allow"
          "::1/128 allow"
          "192.168.48.0/20 allow"
        ];
        interface = [
          "127.0.0.1"
          "::1"
          "192.168.61.0"
          "192.168.52.1"
        ];
      };
    };
  };
}
