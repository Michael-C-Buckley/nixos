{...}: {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  networking = {
    ospf.enable = true;
    hostId = "8425e349";
    networkmanager.enable = true;
  };
}
