_: {
  imports = [./filesystems.nix];

  networkd = {
    eno1.addresses.ipv4 = ["192.168.48.31/24"];
    enusb1 = {
      mac = "6c:1f:f7:06:27:8e";
      addresses.ipv4 = ["192.168.254.1/27"];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.1";
    hostId = "ab0406ca";

    ospf.defaultRoute = {
      metricType = 1;
      metric = 520;
    };
  };

  services.keepalived.vrrpInstances.wan = {
    priority = 110;
  };

  system = {
    boot.uuid = "6B03-5772";
  };

  # CONTAINERS
  containers = {
    wireguard-mt1.autoStart = true;
  };

  virtualisation.quadlet.containers = {
    vaultwarden.autoStart = true;
  };
}
