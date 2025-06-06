_: {
  imports = [
    ./routing.nix
  ];

  networking = {
    useDHCP = true;
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
