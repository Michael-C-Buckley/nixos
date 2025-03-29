_: {
  imports = [
    ./frr.nix
    ./interfaces.nix
    ./settings.nix
    ./systemd.nix
  ];

  services.ntpd-rs.enable = true;
}