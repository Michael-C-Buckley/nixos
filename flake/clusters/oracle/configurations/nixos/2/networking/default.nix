_: {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  networking = {
    hostId = "a07f02cb";
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
