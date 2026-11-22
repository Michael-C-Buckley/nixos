{
  imports = [ ../../modules/nixos/network/netplan ];

  systemd.network.enable = true;

  services = {
    iperf3 = {
      enable = true;
      openFirewall = true;
    };
    frr = {
      bgpd.enable = true;
      ospfd.enable = true;
      bfdd.enable = true;
    };
  };

  networking = {
    hostId = "272a6fae";
    useDHCP = false;
    dhcpcd.enable = false;
    networkmanager.enable = false;
    netplan.configurations."70-b550.yaml" = import ./netplan.nix;
  };
}
