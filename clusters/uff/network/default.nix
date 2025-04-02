_: {
  imports = [
    ./interfaces.nix
    ./routing.nix
    ./settings.nix
    ./systemd.nix
  ];

  services.ntpd-rs.enable = true;
}
