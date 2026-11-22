{
  # NetworkManager is the common network stack across T14g5's installations
  # (NixOS, Finix, Debian, Gentoo). Its defaults (DHCPv4/DHCPv6/RA everywhere,
  # route metric 100 for Ethernet and 600 for Wi-Fi) match the former netplan
  # setup. Connection profiles live on the shared @networkmanager subvolume.
  networking = {
    hostId = "ad56e78a";
    useDHCP = false;
    networkmanager.enable = true;
  };

  users.users.michael.extraGroups = [ "networkmanager" ];

  services.resolved.enable = true;
}
