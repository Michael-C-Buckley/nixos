{...}: {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  services.unbound.enable = true;

  networking = {
    ospf.enable = true;
    hostId = "8425e349";
    networkmanager.enable = true;
  };
}
