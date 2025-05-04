_: {
  imports = [
    ./routing.nix
  ];

  networking = {
    useDHCP = true;
    hostName = "o3";
    hostId = "f82ab703";
    firewall = {
      allowedUDPPortRanges = [
        {
          from = 33500;
          to = 33510;
        }
      ];
    };
  };
}
