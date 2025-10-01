_: {
  networking = {
    hostId = "8c3d4e62";
    hostName = "o1";
    firewall = {
      allowedUDPPortRanges = [
        {
          from = 33400;
          to = 33410;
        }
        {
          from = 33500;
          to = 33510;
        }
      ];
    };
  };
}
