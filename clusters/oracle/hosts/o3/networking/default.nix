_: {
  imports = [
    ./routing.nix
  ];

  networking = {
    hostName = "o2";
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
