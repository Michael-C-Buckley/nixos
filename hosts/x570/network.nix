{
  imports = [ ../../modules/nixos/network/netplan ];

  systemd.network.enable = true;

  networking = {
    hostId = "c07fa570";
    useDHCP = false;
    dhcpcd.enable = false;
    networkmanager.enable = false;
    netplan.configurations."70-x570.yaml" = import ./netplan.nix;
  };

  virtualisation.libvirtd.allowedBridges = [
    "br1"
    "br100"
  ];

  services.iperf3 = {
    enable = true;
    openFirewall = true;
  };
}
