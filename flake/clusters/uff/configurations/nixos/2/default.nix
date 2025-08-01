_: {
  imports = [./filesystems.nix];

  networkd = {
    eno1.addresses.ipv4 = ["192.168.48.32/24"];
    enusb1 = {
      mac = "6c:1f:f7:06:27:ae";
      addresses.ipv4 = ["192.168.254.2/27"];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.2";
    hostId = "072294f5";

    ospf.defaultRoute = {
      metricType = 1;
      metric = 510;
    };
  };

  services.keepalived.vrrpInstances.wan = {
    priority = 120;
  };

  system = {
    boot.uuid = "E8D1-BB86";
  };

  # CONTAINERS
  virtualisation.quadlet.containers = {
    forgejo.autoStart = true;
  };
}
