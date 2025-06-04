_: {
  imports = [
    ./fabric.nix
    ./options.nix
    ./routing.nix
    ./systemd.nix
  ];

  networking = {
    useNetworkd = true;
    networkmanager.enable = true;
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
