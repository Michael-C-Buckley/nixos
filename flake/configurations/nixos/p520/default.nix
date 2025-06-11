_: {
  imports = [
    ./networking
    ./systemd
    ./hardware.nix
  ];

  virtualisation = {
    libvirtd.enable = true;
    incus.enable = true;
  };

  system = {
    impermanence.enable = true;
    boot.uuid = "D8CD-79D6";
    preset = "server";
    stateVersion = "24.05";
    zfs.enable = true;
  };
}
