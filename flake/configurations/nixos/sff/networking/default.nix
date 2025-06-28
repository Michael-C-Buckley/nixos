_: {
  imports = [
    ./options.nix
    ./routing.nix
    ./systemd.nix
  ];

  networking = {
    useNetworkd = true;
    networkmanager.enable = false;
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
  };

  services = {
    ntpd-rs.enable = true;
    iperf3 = {
      enable = true;
      openFirewall = true;
    };
  };
}
