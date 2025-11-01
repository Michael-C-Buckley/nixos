{
  flake.modules.nixos.uff = {
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
    };
  };
}
