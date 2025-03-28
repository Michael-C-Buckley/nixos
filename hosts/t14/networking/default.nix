{...}: {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  networking = {
    hostName = "t14";
    hostId = "8425e349";
    networkmanager.enable = true;

    firewall = {
      extraInputRules = ''
        ip protocol 89 accept comment "Allow OSPF"
      '';
    };
  };
}
