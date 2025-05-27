{lib, ...}: {
  imports = [
    ./corosync.nix
    ./filesystems.nix
    ./hardware.nix
    ./podman.nix
    ./secrets.nix
  ];

  system = {
    preset = "server";
    stateVersion = lib.mkDefault "25.11";
  };
  services.glusterfs.enable = true;
}
