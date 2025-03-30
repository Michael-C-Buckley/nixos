{...}: {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  networking = {
    ospf.enable = true;
    hostName = "t14";
    hostId = "8425e349";
    networkmanager.enable = true;
  };
}
