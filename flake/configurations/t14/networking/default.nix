{...}: {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  services.unbound.enable = true;

  networking = {
    ospf.enable = true;
    hostId = "8425e349";
    hostName = "t14";
    networkmanager.enable = true;

    nat = {
      enable = true;
      externalInterface = "wlp3s0";
      internalInterfaces = ["br0" "br1"];
    };
  };
}
