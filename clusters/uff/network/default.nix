_: {
  imports = [
    ./frr.nix
    ./interfaces.nix
    ./settings.nix
    ./systemd.nix
  ];

  networking.ospf.enable = true;
  services.ntpd-rs.enable = true;
}
