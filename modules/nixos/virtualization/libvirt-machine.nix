{
  imports = [ ../base.nix ];

  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200n8"
  ];

  systemd.services."serial-getty@ttyS0".enable = true;
}
