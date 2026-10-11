{
  networking = {
    hostId = "ad56e78a";
    networkmanager.enable = false;
    useNetworkd = true;
    useDHCP = false;

    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = false;
    };
  };

  services.resolved.enable = true;

  systemd.network = {
    enable = true;

    # Basic wired and wireless templates
    networks = {
      "20-wifi" = {
        matchConfig.Type = "wlan";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
        dhcpV4Config.RouteMetric = 600;
      };

      "20-ethernet" = {
        matchConfig.Name = "en* eth*";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
        };
        dhcpV4Config.RouteMetric = 100;
      };
    };
  };
}
