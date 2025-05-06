_: {
  imports = [
    ./corosync.nix
    ./filesystems.nix
    ./hardware.nix
    ./options.nix
    ./podman.nix
    ./secrets.nix
  ];

  system = {
    preset = "server";
    stateVersion = "25.05";
  };
  custom.uff.enusb1.ipv4.prefixLength = 27;
  features.podman.enable = true;
  services.glusterfs.enable = true;
}
