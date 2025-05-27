_: {
  imports = [
    ./fabric.nix
    ./options.nix
    ./routing.nix
    ./systemd.nix
  ];

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
  };

  services = {
    ntpd-rs.enable = true;
    iperf3 = {
      enable = true;
      openFirewall = true;
    };
  };
}
