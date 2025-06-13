_: {
  imports = [
    ./routing.nix
  ];

  networking = {
    hostName = "x370";
    ospf.enable = true;
    hostId = "726afe29";
    loopback.ipv4 = "192.168.78.100";
  };
}
