{lib, ...}: {
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
    stateVersion = lib.mkDefault "25.11";
  };
  custom.uff.enusb1.ipv4.prefixLength = 27;
  services.glusterfs.enable = true;
}
