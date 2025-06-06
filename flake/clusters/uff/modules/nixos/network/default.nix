_: {
  imports = [
    ./fabric.nix
    ./routing.nix
    ./options.nix
    ./systemd.nix
    ./vrrp.nix
  ];

  networking = {
    useNetworkd = true;
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      eno1.useDHCP = true;
      enusb1.useDHCP = false;
    };
  };

  services = {
    ntpd-rs.enable = true;
    iperf3 = {
      enable = true;
      openFirewall = true;
    };
  };
}
