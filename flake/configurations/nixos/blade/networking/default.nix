_: {
  imports = [
    ./routing.nix
  ];

  networking = {
    ospf.enable = true;
    hostId = "c07fa570";
    loopback.ipv4 = "192.168.78.99";
  };
}
