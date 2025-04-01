_: {
  imports = [
    ./interfaces.nix
    ./routing.nix
  ];

  systemd.network.enable = true;
}
